import json
from Ejercicio2.TranslationDecorator import TranslationDecorator
from Ejercicio2.basicLLM import BasicLLM

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

# TEMP
print('Reading')
with open('SampleText.txt', 'r') as f:
    t = f.read()

llm = BasicLLM(config['model_llm'], token=LLM_token)
translator = TranslationDecorator(llm, config['model_translation'], token=LLM_token)
out = translator.generate_summary(t, config['input_lang'], config['output_lang'])
print(out)

