from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from ..database import SessionLocal, Base, engine
from .. import schemas, crud

router = APIRouter(prefix="/todos", tags=["todos"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.on_event("startup")
def on_startup():
    # برای سادگی آموزشی: ساخت جدول‌ها در استارتاپ
    Base.metadata.create_all(bind=engine)

@router.get("/", response_model=list[schemas.TodoOut])
def list_(db: Session = Depends(get_db)):
    return crud.list_todos(db)

@router.post("/", response_model=schemas.TodoOut, status_code=201)
def create_(data: schemas.TodoCreate, db: Session = Depends(get_db)):
    return crud.create_todo(db, data)

@router.get("/{todo_id}", response_model=schemas.TodoOut)
def get_(todo_id: int, db: Session = Depends(get_db)):
    todo = crud.get_todo(db, todo_id)
    if not todo:
        raise HTTPException(404, "Not found")
    return todo

@router.put("/{todo_id}", response_model=schemas.TodoOut)
def update_(todo_id: int, data: schemas.TodoUpdate, db: Session = Depends(get_db)):
    todo = crud.update_todo(db, todo_id, data)
    if not todo:
        raise HTTPException(404, "Not found")
    return todo

@router.delete("/{todo_id}", status_code=204)
def delete_(todo_id: int, db: Session = Depends(get_db)):
    ok = crud.delete_todo(db, todo_id)
    if not ok:
        raise HTTPException(404, "Not found")
