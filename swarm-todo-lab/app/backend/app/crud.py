from sqlalchemy.orm import Session
from . import models, schemas

def create_todo(db: Session, data: schemas.TodoCreate):
    todo = models.Todo(title=data.title, description=data.description)
    db.add(todo)
    db.commit()
    db.refresh(todo)
    return todo

def list_todos(db: Session):
    return db.query(models.Todo).order_by(models.Todo.id.desc()).all()

def get_todo(db: Session, todo_id: int):
    return db.get(models.Todo, todo_id)

def update_todo(db: Session, todo_id: int, data: schemas.TodoUpdate):
    todo = db.get(models.Todo, todo_id)
    if not todo:
        return None
    for k, v in data.model_dump(exclude_unset=True).items():
        setattr(todo, k, v)
    db.commit()
    db.refresh(todo)
    return todo

def delete_todo(db: Session, todo_id: int):
    todo = db.get(models.Todo, todo_id)
    if not todo:
        return False
    db.delete(todo)
    db.commit()
    return True
