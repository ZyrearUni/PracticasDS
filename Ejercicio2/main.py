import json

from abc import ABC, abstractmethod

config_filename = 'config.json'

LLM_token_filename = 'token.txt'

print('Starting...')

with open(config_filename, 'r') as f:
    config = json.load(f)
    # print(config)
try:
    with open(LLM_token_filename, 'r') as f:
        LLM_token = f.read()
        # print(LM_token)
except:
    print('No LLM token file found. Please create a file with the correct name with a valid token')
    raise


class LLM(ABC):
    @abstractmethod
    def generate_summary(self, text, input_lang, output_lang):
        pass


import requests

# "https://api-inference.huggingface.co/models/

class BasicLLM(LLM):
    def __init__(self, model):
        self.model = model
    def generate_summary(self, text, input_lang, output_lang):
        API_URL = f"https://api-inference.huggingface.co/models/{self.model}"
        headers = {"Authorization": f"Bearer {LLM_token}",}
        payload = {"inputs": text,}
        response = requests.post(API_URL, headers=headers, json=payload)
        response.json()
        print(response.json())
        return response.json()[0]['summary_text']

class Decorator(LLM):
    def __init__(self, base):
        self.base = base
    @abstractmethod
    def generate_summary(self, text, input_lang, output_lang):
        pass


class TranslationDecorator(Decorator):
    def __init__(self, base, model):
        super().__init__(base)
        self.model = model
    def generate_summary(self, text, input_lang, output_lang):

        self.base.generate_summary(text, input_lang, output_lang)

        print(123)
        API_URL = f"https://api-inference.huggingface.co/models/{self.model}"
        headers = {"Authorization": f"Bearer {LLM_token}",}
        payload = {"inputs": text, }
        response = requests.post(API_URL, headers=headers, json=payload)
        response.json()
        print(response.json())
        return response.json()[0]['translation_text']


# TEMP
print ('Reading')
with open('SampleText.txt', 'r') as f:
    t = f.read()

'''
llm = BasicLLM(config['model_llm'])
output = llm.generate_summary(config['text'], config['input_lang'], config['output_lang'], config['model_llm'])
'''
llm = BasicLLM(config['model_llm'])
translator = TranslationDecorator(llm, config['model_translation'])
out = translator.generate_summary(t, config['input_lang'], config['output_lang'])
print(out)

