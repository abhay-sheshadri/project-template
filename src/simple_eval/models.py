from pathlib import Path

from src.tooling import complete
from src.utils import load_prompt_file


class BasicModel:
    """Minimal async wrapper around the inference API."""

    def __init__(
        self, name: str, model_id: str, temperature: float = 1.0, max_tokens: int = 2000
    ):
        self.name = name
        self.model_id = model_id
        self.temperature = temperature
        self.max_tokens = max_tokens

    async def __call__(self, messages: list[dict]) -> str:
        return await complete(
            messages,
            model=self.model_id,
            temperature=self.temperature,
            max_tokens=self.max_tokens,
        )


class SystemPromptModel(BasicModel):
    """BasicModel with a system prompt injected into every call."""

    def __init__(
        self,
        name: str,
        model_id: str,
        system_prompt: str | None = None,
        system_prompt_path: str | Path | None = None,
        temperature: float = 1.0,
        max_tokens: int = 2000,
    ):
        super().__init__(
            name=name, model_id=model_id, temperature=temperature, max_tokens=max_tokens
        )
        if bool(system_prompt) == bool(system_prompt_path):
            raise ValueError(
                "Specify exactly one of system_prompt or system_prompt_path"
            )
        self.system_prompt = (
            load_prompt_file(system_prompt_path).strip()
            if system_prompt_path
            else system_prompt.strip()
        )

    def _prepare_messages(self, messages: list[dict]) -> list[dict]:
        messages = list(messages)
        if messages and messages[0]["role"] == "system":
            messages[0] = {
                "role": "system",
                "content": self.system_prompt + "\n\n" + messages[0]["content"],
            }
        else:
            messages.insert(0, {"role": "system", "content": self.system_prompt})
        return messages

    async def __call__(self, messages: list[dict]) -> str:
        return await super().__call__(self._prepare_messages(messages))
