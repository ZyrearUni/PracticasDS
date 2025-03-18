import requests
import LLM

class BasicLLM(LLM):
    def __init__(self, model, token):
        self.model = model
        self.token = token
    def generate_summary(self, text, input_lang, output_lang):
        API_URL = f"https://api-inference.huggingface.co/models/{self.model}"
        headers = {"Authorization": f"Bearer {self.token}",}
        payload = {"inputs": text,}
        response = requests.post(API_URL, headers=headers, json=payload)
        response.json()
        return response.json()[0]['summary_text']
