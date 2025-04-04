# SiriusGame 🏆

![Swift](https://img.shields.io/badge/Swift-5.9-orange?logo=swift)
![Platform](https://img.shields.io/badge/iOS-17+-blue?logo=apple)
![CI/CD](https://img.shields.io/badge/CI/CD-Passing-success?logo=github)
![License](https://img.shields.io/badge/License-MIT-green)

**Автоматизация соревнований** для образовательного центра «Сириус» с интерактивными оценками через AirDrop, live-трансляциями результатов, push-нотификацией для оповещения участников о ходе соревнований, картами и построением маршрутов.

---

## 📱 Скриншоты UI
### Список событий
<img src="https://github.com/user-attachments/assets/704792f6-3adb-47db-a142-7f10c0e63273" width="200"/>

### Карта
<img src="https://github.com/user-attachments/assets/4df62382-65df-4491-b2e3-7c20270f93ff" width="200"/>

### Работа Push и экран получения оценки
<img src="https://github.com/user-attachments/assets/53e810b0-12f8-48df-a6f3-572f6aa7ed73" width="200"/>

### Лидербоард
<img src="https://github.com/user-attachments/assets/036e23f2-dd0f-457a-8d7b-b6ce9fa05a2b" width="200"/>


### 

## 🎥 Видеодемо


https://github.com/user-attachments/assets/fe17ef9a-fb22-45f0-afaf-5b902a9fc019

## 🛠 Технологии

### 📱 Клиент
- **Язык**: Swift 5.9
- **UI**: SwiftUI + MapKit
- **Архитектура**: MVVM + Dependency Injection
- **Уведомления**: 
  - `UserNotifications` + APNs (оценки/анонсы)
  - Live Activities (реал-тайм обновления)
- **AirDrop**: Deep Links для передачи оценок
- **Сеть**: Кастомный слой на URLSession

### ⚙️ Инфраструктура
- **Бэкенд**: FastAPI (Python)
- **CI/CD**: 
  - Автопроверки сборки (`xcodebuild`)
  - Линтинг (`SwiftFormat`)
- **Генерация проекта**: XcodeGen
  
---

## ⚙️ Установка и настройка

```bash
# 1. Клонируйте репозиторий
https://github.com/AlexOneZ/SiriusGame.git
cd SiriusGame

# 2. Генерация проекта (через XcodeGen)
xcodegen generate

# 3. Откройте проект в Xcode
open SiriusGame.xcworkspace

```
## Установка Swiftformat
```bash
brew install swiftformat
```

## 🧑‍💻 Команда

| Роль               | Участник           | GitHub                                      | Контакты               |
|--------------------|--------------------|---------------------------------------------|------------------------|
| iOS-разработчик    | Андрей Степанов    | [@TheRain231](https://github.com/TheRain231)| [@TheRain231](https://web.telegram.org/k/#@TheRain231) |
| iOS-разработчик    | Мария Майорова     | [@mariaamay](https://github.com/mariaamay)  | [@by_mvm](https://web.telegram.org/k/#@by_mvm)|
| iOS-разработчик    | Алексей Кобяков    | [@AlexOneZ](https://github.com/AlexOneZ)    | [@aleksey_k99](https://web.telegram.org/k/#@aleksey_k99) |
| iOS-разработчик    | Илья Лебедев       | [@realINL](https://github.com/realINL)      | [@twa777](https://web.telegram.org/k/#@twa777) |
| Backend            | Рамин Султангалиев | [@raminsultangaliev](https://github.com/raminsultangaliev)      | [@rsul07](https://web.telegram.org/k/#@rsul07) |
| Backend            | Михаил Батурин     | [@Misha-Mayskiy](https://github.com/Misha-Mayskiy)    | [@cubebug](https://web.telegram.org/k/#@cubebug) |

