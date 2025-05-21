import firebase_admin  
from firebase_admin import credentials, firestore  
from sentence_transformers import SentenceTransformer, util  
import numpy as np  

# Initialize Firebase Admin SDK  
cred = credentials.Certificate('path/to/serviceAccountKey.json')  # Replace path  
firebase_admin.initialize_app(cred)  
db = firestore.client()  

# Load embedding model (sentence transformer)  
model = SentenceTransformer('all-MiniLM-L6-v2')  

def embed_text(text):  
    return model.encode(text, convert_to_tensor=True)  

def get_user_offered_skills(user_id):  
    """Get all offered skills of a user."""  
    docs = db.collection('skills').where('userId', '==', user_id).stream()  
    return [doc.to_dict() for doc in docs]  

def get_user_active_requests(user_id):  
    """Get all active skill requests of a user."""  
    docs = db.collection('requests').where('userId', '==', user_id).stream()  
    return [doc.to_dict() for doc in docs]  

def get_all_offers_except_user(user_id):  
    """Get all offered skills from all users except the given one."""  
    docs = db.collection('skills').where('userId', '!=', user_id).stream()  
    return [(doc.id, doc.to_dict()) for doc in docs]  

def find_best_matches_for_request(request_doc):  
    """  
    For a given request (skillName, description, userId, exchangePreferences),  
    find all users who offer matching skills,  
    then check if they request any of the requesting user's offered skills,  
    return matches with reason (mutual skill/volunteer/fee).  
    """  
    user_id = request_doc['userId']  
    requested_skill_name = request_doc['skillName']  
    requested_description = request_doc.get('description', requested_skill_name)  
    exchange_prefs = request_doc.get('exchangePreferences', [])  

    # Embed the requested skill text  
    req_emb = embed_text(requested_description)  

    # Get all offers excluding requester  
    offers = get_all_offers_except_user(user_id)  

    # Get all skills this user offers  
    user_offers = get_user_offered_skills(user_id)  

    # Precompute embeddings for user's offered skills descriptions/names as fallback for mutual match  
    user_offer_texts = [skill.get('description', skill.get('name', '')) for skill in user_offers]  
    user_offer_embeddings = [embed_text(text) for text in user_offer_texts]  

    matches = []  

    for off_id, offer in offers:  
        offer_user_id = offer['userId']  
        offer_skill_desc = offer.get('description', offer.get('name', ''))  
        offer_emb = embed_text(offer_skill_desc)  

        # Check semantic similarity between request and this offer to filter relevant offers  
        similarity = util.cos_sim(req_emb, offer_emb).item()  
        if similarity < 0.7:  
            continue  # skip non-matching offers  

        # Check if this offer user has any requests that match any skill that user_id offers (mutual)  
        off_user_requests = get_user_active_requests(offer_user_id)  

        mutual_request_found = False  
        mutual_requested_skill_name = None  

        for off_req in off_user_requests:  
            off_req_desc = off_req.get('description', off_req.get('skillName', ''))  
            off_req_emb = embed_text(off_req_desc)  

            # Check for mutual match: if off_req matches any of user_id's offers  
            for user_emb in user_offer_embeddings:  
                mutual_sim = util.cos_sim(off_req_emb, user_emb).item()  
                if mutual_sim > 0.7:  
                    mutual_request_found = True  
                    mutual_requested_skill_name = off_req.get('skillName', off_req.get('description', ''))  
                    break  
            if mutual_request_found:  
                break  

        if mutual_request_found:  
            # Perfect mutual skill matching  
            matches.append({  
                'requesterUserId': user_id,  
                'offerUserId': offer_user_id,  
                'requestedSkillByRequester': requested_skill_name,  
                'requestedSkillByOfferUser': mutual_requested_skill_name,  
                'offerSkillName': offer.get('name'),  
                'exchangeType': 'skill',  
                'similarityScore': similarity,  
            })  
        else:  
            # No mutual match, fallback on exchange preferences  
            # For simplicity, store the exchange preferences of the requester’s request in the match.  
            if exchange_prefs:  
                matches.append({  
                    'requesterUserId': user_id,  
                    'offerUserId': offer_user_id,  
                    'requestedSkillByRequester': requested_skill_name,  
                    'offerSkillName': offer.get('name'),  
                    'exchangeType': ','.join(exchange_prefs),  
                    'similarityScore': similarity,  
                })  

    return matches  

def save_matches_to_firestore(matches):  
    batch = db.batch()  
    matches_ref = db.collection('matches')  

    for idx, match in enumerate(matches):  
        # Compose document id for consistent overwriting (optional)  
        doc_id = f"{match['requesterUserId']}_{match['offerUserId']}_{idx}"  
        doc_ref = matches_ref.document(doc_id)  
        batch.set(doc_ref, {  
            **match,  
            'timestamp': firestore.SERVER_TIMESTAMP  
        })  
    batch.commit()  

def main():  
    """Main entry: find new requests and compute matches."""  
    # Query recent requests that do not have matches yet (you may want to filter by time)  
    requests = db.collection('requests').stream()  

    for req_doc in requests:  
        req_data = req_doc.to_dict()  
        matches = find_best_matches_for_request(req_data)  
        if matches:  
            save_matches_to_firestore(matches)  
            print(f"Saved {len(matches)} matches for request by user {req_data['userId']}")  
        else:  
            print(f"No matches found for request by user {req_data['userId']}")  

if __name__ == "__main__":  
    main()