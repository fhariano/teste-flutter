# 🚀 test_flutter
Aplicação Web, Android e iOS para teste de vaga de desenvolvedor Flutter

## 🧩 Funcionalidades

- ✅ CRUD de usuários.
- ✅ Telas de Login e Registrar.
- ✅ Login utilizando FIREBASE AUTHENTICATION com CPF/PASSWORD. (funcional)
- ✅ Checkbox: Lembrar Sempre. (funcional)
- ✅ Esqueci Minha Senha. (funcional)
- ✅ Redes sociais apenas como ícones ilustrativos. (backlog)
- ✅ Tela HOME com informações do usuário.
- ✅ Área para COTAR e CONTRATAR seguros.
- ✅ Seções: Minha Família e Contratados.
- ✅ Menu lateral tipo DRAWER com AVATAR e informações do usuário.
- ✅ Ao clicar no card "Automóvel", abrir uma WebView com qualquer site externo.

## 📦 Deploy Local

### Requisitos

- SDK Flutter v. 3.32.7 (Stable)
- Visual Studio Code

### 1️⃣ Clone o projeto

```
git clone https://github.com/fhariano/teste-flutter.git
cd teste-flutter
```

### 2️⃣ Teste web: No terminal executar

```
flutter pub get
flutter run -d chrome
```

### 3️⃣ Teste Android

```
Instalar o Android Studio
Criar um emulador ex.: Pixel 4 API 29
Executar o emulador
No VsCode selecionar o emulador criado e executar: Run Without Debugging
```

### Acesso funcional p/ testes (válido até 01/08/2025 às 20h)
```
http://test.arianoti.com.br/
```

### Login para teste
```
cpf: 37938138193 
pwd: password
```

### Observações:
1. No pacote está incluso as credenciais do projeto no FIREBASE AUTHENTICATION, porém, isto não é uma boa prática de segurança, mas o acesso está restrito até 01/08/2025.
O procedimento seguro é, configurar o .git para não enviar as credenciais ao repositório e incluir neste documento README.MD o passo a passo de criação de uma aplicação no FIREBASE e a configuração necessária no projeto Flutter!

2. Na função Esqueci Minha Senha ao receber o e-mail verificar também na caixa de SPAM!

## Getting Started with Flutter

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
