## Ключевые файлы:

1. **Vagrantfile** - создает Ubuntu 22.04 VM, пробрасывает порты
2. **prov.yml** - Ansible playbook для развертывания приложений
3. **project/nginx-conf/nginx.conf** - конфиг Nginx с проксированием
4. **project/node/test.js** - Node.js приложение
5. **project/python/** - Django приложение

## Запуск и проверка:

```bash
# Полная пересборка
vagrant destroy -f
vagrant up

# Быстрая проверка
curl http://localhost:8081/
curl http://localhost:8082/
curl http://localhost:8083/
Результат по пути проекта project/screens
