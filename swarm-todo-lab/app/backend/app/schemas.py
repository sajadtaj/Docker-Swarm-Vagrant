from pydantic import BaseModel

class TodoCreate(BaseModel):
    title: str
    description: str | None = None

class TodoUpdate(BaseModel):
    title: str | None = None
    description: str | None = None
    is_done: bool | None = None

class TodoOut(BaseModel):
    id: int
    title: str
    description: str | None
    is_done: bool

    class Config:
        from_attributes = True
