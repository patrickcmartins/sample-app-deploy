# sample-app-deploy

O **estado desejado** do sample-app em cada cluster. O Argo CD do hub lê este repo
(ApplicationSet `sample-app` no `platform-gitops`), e uma app só nasce quando existe `envs/<cluster>/config.yaml`
**e** o cluster está registrado com `workloads=enabled`.

```
chart/              Helm: Deployment por versão, Service, DestinationRule, VirtualService, AuthorizationPolicy
envs/kind-dev/      dev: a tag é atualizada pelo CI do sample-app (CD automático)
envs/eks-prod/      prod: só muda por PR (workflow "promote") + CODEOWNERS
```

## Por que separar o código do deploy?

* Um commit de código não dispara sync, e uma mudança de réplicas não dispara build.
* O histórico deste repo **é** o log de deploys, e rollback é `git revert`.
* As permissões ficam separadas: o CI de app só escreve em `envs/kind-dev`, e prod exige review.

## Canary em prod

```yaml
versions:
  - { name: stable, weight: 90, replicas: 2 }
  - { name: canary, weight: 10, replicas: 1, tag: sha-novo }
```

1. `curl -H 'x-version: canary' ...` testa a versão nova sem peso nenhum.
2. Suba os pesos aos poucos (10 → 50 → 100) e depois faça do canary a `stable`.

O `values.schema.json` bloqueia `latest` e o template falha se a soma dos pesos for diferente de 100.
