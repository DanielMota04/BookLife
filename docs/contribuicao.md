# Como Contribuir

## Antes de começar

Sempre atualize sua cópia local da `main` antes de criar uma branch nova:

```bash
git checkout main
git pull origin main
```

Depois crie uma branch para a sua tarefa:

```bash
git checkout -b feature/nome-da-tela
```

---

## Padrão de nome de branch

- `feature/` pra coisa nova → `feature/login`
- `fix/` pra correção de bug → `fix/erro-no-cadastro`

Mantenha o nome curto, em minúsculas, com hífen no lugar de espaço.

---

## Padrão de commit

Mensagens curtas, em português, descrevendo o que foi feito:

```
adiciona tela de login
corrige validação do campo de email
ajusta cores do tema
```

Faça commits pequenos e frequentes. Evite commits gigantes.

---

## Enquanto desenvolve

- Trabalhe apenas nos arquivos da sua tela/feature
- Se precisar mexer em algo compartilhado, avise no grupo antes

---

## Ao terminar

1. Atualize sua branch com a `main`, caso outras pessoas tenham subido coisas:

```bash
git checkout main
git pull origin main
git checkout feature/nome-da-tela
git merge main
```

2. Resolva conflitos se aparecerem, peça ajuda no grupo se ficar perdido

3. Faça o push:

```bash
git push origin feature/nome-da-tela
```

4. Abra um Pull Request no GitHub explicando brevemente o que foi feito

5. Peça para alguem do grupo revisar antes do merge

6. Só faça merge na `main` depois da revisão

---

## Boas práticas de código

- Nomes de variáveis e funções em inglês (`login`, `getBooks`, `userName`)
- Textos que aparecem na tela em português
- Se mexer em algo que não é da sua tarefa, comente no PR explicando

---

## Comunicação no grupo

- Avise quando começar uma tarefa
- Avise quando abrir um PR
