from abc import abstractmethod

import LLM


class Decorator(LLM):
    def __init__(self, base):
        self.base = base

    @abstractmethod
    def generate_summary(self, text, input_lang, output_lang):
        pass
