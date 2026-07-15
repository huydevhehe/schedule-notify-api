# Schedule Notify API

A Django REST Framework backend for an internal meeting-schedule notification system. It lets client apps authenticate, look up the current user's role and units, and read/create/update/delete meetings scoped to organizational units, with admin/employee role-based permissions.

**Author:** Nguyễn Quốc Huy

## Tech Stack

- Python 3, Django 5
- Django REST Framework
- djangorestframework-simplejwt (JWT authentication)
- django-environ (environment-based configuration)
- SQLite for local development, PostgreSQL-ready via `DATABASE_URL`

## Features

- JWT login (`POST /api/auth/login/`, `POST /api/auth/refresh/`)
- Current user profile: role and unit membership (`GET /api/me/`)
- Units the current user belongs to (`GET /api/units/`)
- Meetings scoped to the user's units (`GET/POST /api/meetings/`, `GET/PATCH/DELETE /api/meetings/<id>/`)
- Role-based permissions: only unit admins can create/edit/delete meetings for their own unit; employees have read-only access

## Getting Started

```bash
cd backend
python -m venv venv
source venv/Scripts/activate   # Windows Git Bash
pip install -r requirements.txt
cp .env.example .env           # then set a real SECRET_KEY
python manage.py migrate
python manage.py test
python manage.py runserver
```

## Project Structure

```
backend/
  config/            # Django project settings, URL routing
  apps/
    accounts/        # Unit and User models, auth, /api/me/
    meetings/        # Meeting model and CRUD API
docs/
  superpowers/plans/ # Implementation plans
```

---

# Schedule Notify API (Tiếng Việt)

Backend Django REST Framework cho hệ thống thông báo lịch họp nội bộ. Cho phép ứng dụng client đăng nhập, tra cứu vai trò/đơn vị của người dùng hiện tại, và xem/tạo/sửa/xóa lịch họp theo đơn vị, với phân quyền admin/nhân viên.

**Tác giả:** Nguyễn Quốc Huy

## Công nghệ sử dụng

- Python 3, Django 5
- Django REST Framework
- djangorestframework-simplejwt (xác thực bằng JWT)
- django-environ (cấu hình qua biến môi trường)
- SQLite cho môi trường phát triển, sẵn sàng chuyển sang PostgreSQL qua `DATABASE_URL`

## Tính năng

- Đăng nhập bằng JWT (`POST /api/auth/login/`, `POST /api/auth/refresh/`)
- Thông tin người dùng hiện tại: vai trò và đơn vị (`GET /api/me/`)
- Danh sách đơn vị của người dùng hiện tại (`GET /api/units/`)
- Lịch họp theo đơn vị (`GET/POST /api/meetings/`, `GET/PATCH/DELETE /api/meetings/<id>/`)
- Phân quyền theo vai trò: chỉ admin của đơn vị mới được tạo/sửa/xóa lịch họp của đơn vị mình; nhân viên chỉ được xem

## Bắt đầu

```bash
cd backend
python -m venv venv
source venv/Scripts/activate   # Windows Git Bash
pip install -r requirements.txt
cp .env.example .env           # sau đó đặt SECRET_KEY thật
python manage.py migrate
python manage.py test
python manage.py runserver
```

## Cấu trúc dự án

```
backend/
  config/            # Cấu hình project Django, định tuyến URL
  apps/
    accounts/        # Model Unit và User, xác thực, /api/me/
    meetings/        # Model Meeting và API CRUD
docs/
  superpowers/plans/ # Các plan triển khai
```
