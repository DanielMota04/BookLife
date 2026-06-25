# Arquitetura

## Decisões principais

| Decisão | Escolha |
|---|---|
| Arquitetura | MVVM |
| Organização de pastas | Feature-First |
| Entidades | Com comportamento próprio |
| Backend | Firebase (Auth + Firestore) |

---

## MVVM

O MVVM divide a aplicação em três camadas principais:

- **Model** — os dados em si. Entidades, enums, value objects, etc.
- **View** — os widgets que aparecem na tela.
- **ViewModel** — As funcionalidades da tela, contém os estados e funções que a view pode chamar.

---

## Feature-First

- Agrupa as pastas e códigos por funcionalidades. Exemplo:

```
lib/features/
├── auth/
│   ├── models/
│   ├── repositories/
│   ├── viewmodels/
│   └── views/
└── library/
    ...
```

---

## Estrutura de Pastas

```
lib/
├── app/                # MaterialApp, rotas, tema
├── core/               # Código compartilhado entre features
│   ├── constants/      # Valores fixos (chaves de storage, paths, etc)
│   ├── enums/          # Enums usados em mais de uma feature
│   ├── errors/         # Exceções e classes de erro
│   ├── models/         # Entidades utilizadas em mais de um lugar (User, etc)
│   ├── network/        # Configuração Firebase, clientes HTTP
│   ├── services/       # Serviços externos ao app
│   ├── utils/          # Funções utilitárias (formatadores, validadores)
│   └── widgets/        # Componentes reutilizáveis (botões, banners)
└── features/
    ├── auth/
    │   ├── models/         # Entidades só de auth
    │   ├── repositories/   # Acesso a dados de auth
    │   ├── viewmodels/     # ViewModels das telas de auth
    │   └── views/
    │       ├── widgets/    # Widgets só usados em auth
    │       └── *.dart      # Telas (LoginPage, RegisterPage...)
    ├── library/
    |   ├── models/
    |   └── ...
    ├── collections/
    ├── progress/
    ├── goals/
    ├── reading_timer/
    └── settings/
```

### `lib/app/`

Ponto inicial do app. `MaterialApp`, rotas, tema, etc.

### `lib/core/`

Coisas compartilhadas que não pertencem a nenhuma feature em específico.

### Estrutura interna de uma feature

Toda feature segue o mesmo padrão:

```
features/
└──<feature>/
    ├── models/         # Entidades, value objects etc dessa feature
    ├── repositories/   # Classes de acesso a dados dessa feature (comunicação com o firebase)
    ├── viewmodels/     # Uma ViewModel por tela ou por fluxo
    └── views/
        ├── widgets/    # Widgets usados dentro dessa feature
        └── *.dart      # Telas
```

---

## Definição das camadas

### Model

Define o domínio: entidades, enums, value objects.

- Imutável: todos os campos `final`. Pra alterar, retorna nova instância utilizando o `copyWith`.
- Sem dependências externas.

### Entidades com comportamento próprio

Utiliza do conceito de classes ricas do DDD, aplicando os seguintes conceitos:

- Construtor validando as regras principais (Ex: Quantidade de páginas de um livro não podem ser negativas).
- Métodos que mudam estado (ex: `book.markAsCompleted()`).
- Coisas calculadas viram getters (ex: `bool get isInProgress`).

### Repository

Repository é a camada que se comunica com o banco. Ele expõe métodos em termos do domínio (`getBookById(id)`, `saveBook(book)`) e esconde tudo que tá embaixo.

- ViewModel não conversa direto com Firestore, só com Repository.
- Repository devolve entidades.

### ViewModel

ViewModel guarda o comportamento da tela.

- Guarda o estado observável (loading, erro, dados, filtros).
- Recebe eventos do usuário e age em cima disso: chama Repository, atualiza estado, etc.
- Uma ViewModel por tela.

### View

Só widget. Lê o estado da ViewModel, mostra na tela e chama os métodos quando o usuário faz algo.

- Não chama Repository direto.
- Não tem lógica de negócio.
- Não valida coisas do domínio.

---

## Regra de Dependência

A dependência sempre flui numa direção:

```
View → ViewModel → Repository → Model
```

- View conhece ViewModel; ViewModel não conhece View.
- ViewModel conhece Repository; Repository não conhece ViewModel.
- Repository conhece Model; Model não conhece Repository.
- Model não conhece ninguém.

---

## Convenções de Nomenclatura

| Elemento | Convenção | Exemplo |
|---|---|---|
| Pastas | `snake_case` | `reading_timer/` |
| Arquivos | `snake_case` com sufixo do tipo | `book_model.dart`, `library_viewmodel.dart`, `library_page.dart`, `book_repository.dart` |
| Classes | `PascalCase` | `Book`, `LibraryViewModel`, `BookRepository` |
| Enums | `PascalCase` | `ReadingStatus` |
| Telas | sufixo `Page` | `LoginPage`, `LibraryPage` |
| Repositórios | sufixo `Repository` | `BookRepository`, `GoalRepository` |
| ViewModels | sufixo `ViewModel` | `LibraryViewModel`, `ReadingTimerViewModel` |
