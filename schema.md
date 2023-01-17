```mermaid

erDiagram

total |o--|| session : "1 : 1"
session ||--|{ group : "1 : n"


total {
  int id PK
  int session_id FK
  date finished_at
  int total_expense
}

session {
  int id PK
  date will_finish_at
  date started_at
}

group {
  int id PK
  int session_id FK
  int attendance_num
  int labor_cost_per_hour
  int estimated_sales_per_hour
}