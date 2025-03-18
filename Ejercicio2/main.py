import json

from Ejercicio2.ExpansionDecorator import ExpansionDecorator
from TranslationDecorator import TranslationDecorator
from BasicLLM import BasicLLM

if __name__ == '__main__':
    config_filename = 'config.json'
    LLM_token_filename = 'token.txt'

    print('Loading config files...')

    with open(config_filename, 'r') as f:
        config = json.load(f)
        # print(config)
    try:
        with open(LLM_token_filename, 'r') as f:
            LLM_token = f.read()  # we could also but token in the config file
            # pero asi' en el github es mas facil (gitignore token.txt)
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
    expander = ExpansionDecorator(translator, config['model_expansion'], token=LLM_token)
    out = expander.generate_summary(t, config['input_lang'], config['output_lang'])
    print(out)
