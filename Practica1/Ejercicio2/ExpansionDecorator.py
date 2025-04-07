import requests

from Decorator import Decorator


class ExpansionDecorator(Decorator):
    def __init__(self, base, model, token):
        super().__init__(base)
        self.model = model
        self.token = token

    def generate_summary(self, text, input_lang, output_lang):
        summarized = self.base.generate_summary(text, input_lang, output_lang)
        print(1231231)
        print(summarized)
        prompt = ("Este es un resumen de un texto en español, por favor amplíelo. Dame como resultado solo el texto "
                  "ampliado sin consejos su como ampliarlo y sin notas. El texto tiene que ser en español: \n")

        API_URL = f"https://api-inference.huggingface.co/models/{self.model}"
        headers = {"Authorization": f"Bearer {self.token}", }
        payload = {"inputs": prompt + summarized, "parameters": {"return_full_text": False}}

        response = requests.post(API_URL, headers=headers, json=payload)

        return response.json()[0]['generated_text']
