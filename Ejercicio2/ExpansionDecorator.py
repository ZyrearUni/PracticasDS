import requests

from Decorator import Decorator


class ExpansionDecorator(Decorator):
    def __init__(self, base, model, token):
        super().__init__(base)
        self.model = model
        self.token = token

    def generate_summary(self, text, input_lang, output_lang):
        summarized = self.base.generate_summary(text, input_lang, output_lang)
        prompt = "Este es un resumen de un texto en español, por favor amplíelo. \n"

        API_URL = f"https://api-inference.huggingface.co/models/{self.model}"
        headers = {"Authorization": f"Bearer {self.token}", }
        payload = {"inputs": prompt + summarized, }

        response = requests.post(API_URL, headers=headers, json=payload)
        response.json()
        return response.json()
