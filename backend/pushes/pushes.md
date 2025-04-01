**Проверить файл `.env`**

Убедитесь, что в корне проекта есть файл `.env` с правильными значениями для:

```dotenv
APNS_AUTH_KEY_PATH=путь/к/вашему/файлу/AuthKey_YOURKEYID.p8
APNS_KEY_ID=YOUR_KEY_ID
APNS_TEAM_ID=YOUR_TEAM_ID
APNS_APP_BUNDLE_ID=com.yourcompany.yourapp # Bundle ID вашего iOS приложения
# APNS_USE_SANDBOX=true # Раскомментируйте и установите true, если тестируете с Development сборкой
```

**Проверка:**

1.  Перезапустите сервер FastAPI.
2.  Попробуйте снова выполнить запрос к `/pushes/register` через `/docs`. Теперь не должно быть ошибки `500 Internal Server Error` из-за `local_kw`. Query-параметр `local_kw` будет просто проигнорирован, так как он не объявлен ни в пути, ни как параметр функции роутера.
3.  Тело запроса для `/pushes/register` должно содержать как минимум `token`:
    ```json
    {
      "token": "РЕАЛЬНЫЙ_ИЛИ_ТЕСТОВЫЙ_ДЕВАЙС_ТОКЕН",
      "name": "Mike's iPhone",
      "systemName": "iOS",
      "systemVersion": "17.4",
      "model": "iPhone",
      "localizedModel": "iPhone"
    }
    ```
    Поля `id`, `created_at`, `updated_at` не нужно передавать, они управляются базой данных.
4.  Проверьте эндпоинт `/pushes/send` или `/pushes/send_to_all` для отправки уведомлений.
