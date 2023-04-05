# Terraform Module로 코드 재사용성 높이기

Terraform을 처음 다뤄보면서 보다 효율적인 자동화를 구현하기 위해 Module을 적용한 경험을 소개합니다.

자세한 이야기는 `빅챗 발표자료.pdf`를 참고해주세요.

<br>

## Contents

**⍥ Terraform Basic Concept : 테라폼 기본 컨셉에 대해 알려드릴게요**

- Provisioning과 IaC?
- Terraform과 Terraform Workflow 소개
<br>

**⍥ Terraform Module : 모듈화란 무엇일까요?**

- 모듈화하기 전과 후의 트리 구조 비교
- Terraform Backend를 활용한 상태 관리
<br>

**⍥ Live Demo : 모듈화를 적용하여 리소스 모듈을 재사용하는 데모를 보여드립니다**

<br>
<br>

## Demo Tree Structure & Architecture
**이 데모에서는 network와 ec2 module을 재사용하여 dev와 prod 환경의 인프라를 구축합니다.**

> network module : vpc, subnet, igw, NAT gateway, EIP, route table  
> ec2 module : key(data source), bastion host, private ec2 instances

<img alt="module tree structure" src="https://user-images.githubusercontent.com/70079416/230025387-f166db5f-0c01-4138-80f9-86c619376e02.png" width=50% height=50%>

<br>

### 그럼 이제 데모를 실행해볼게요.

**dev 환경에서는 단일 가용 영역에, prod 환경에서는 다중 가용영역에 EC2 인스턴스를 배포했습니다.**

- 리소스 모듈은 재사용하고, `dev.tfvars`와 `prod.tfvars` 파일에 변수값을 달리 지정해주면 됩니다.
- ec2 인스턴스를 생성하기 위한 key는 콘솔상에 생성되어 있는 key를 data block으로 가져왔어요.

<img alt="architecture" src="https://user-images.githubusercontent.com/70079416/230025362-e9480b2a-48ed-4cba-ab26-652ddf98a267.png" width=80% height=80%>

<br>

## CLI Commands for Demo

데모를 실행하기 위해 사전에 homebrew로 aws cli(v2)와 terraform을 설치해야 해요.

- terraform의 경로를 확인하고 tf로 커맨드를 단축시킬 수 있어요.
  ```bash
  # path
  which terraform
  
  # inject path
  sudo ln ${path}/terraform ${path}/tf
  ```
- 그리고 콘솔에 ec2 인스턴스를 생성하기 위한 key pair가 생성되어 있어야 하고, `modules/ec2/main.tf` 파일에서 최상단의 key data block을 찾아 `key_name`을 변경해줍니다.

<br>
<br>

#### 1. (백엔드 구성 시) global 폴더에서 S3와 DynamoDB 테이블을 먼저 프로비저닝합니다.

```bash
# terraform-demo/global
tf init
tf fmt # check and apply a canonical format
tf validate # verify if configuration files are valid
tf plan --var-file
```

#### 2. dev 환경의 리소스를 프로비저닝합니다.
 - 백엔드를 구성하지 않았다면 `terraform` block으로 작성한 백엔드 코드는 주석처리해주세요!

```bash
# terraform-demo/root/dev
tf init
tf fmt & tf validate # optional step
tf plan --var-file=dev.tfvars
tf apply --var-file=dev.tfvars -auto-approve
```

#### 3. prod 환경의 리소스를 프로비저닝합니다. `.tfvars` 파일만 다르게 적용하면 돼요.

```bash
# terraform-demo/root/prod
tf init
tf fmt & tf validate # optional step
tf plan --var-file=prod.tfvars
tf apply --var-file=prod.tfvars -auto-approve
```

<img alt="instance console" src="https://user-images.githubusercontent.com/70079416/230025375-5a39e2fe-5740-407b-8c7d-4e2d0ea05bbf.png">

<br>

#### 4. 요금이 부과되는 리소스가 포함되어 있으므로 프로비저닝한 리소스를 반드시 삭제합니다.

```bash
# terraform-demo/root/dev
tf destroy -var-file=dev.tfvars

# terraform-demo/root/prod
tf destroy -var-file=prod.tfvars
```

<br>

## References

🖥️ Web : [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

📚 Book : Terraform Up&Running _by Oreilly_

🐹 Support & Advice : **AUSG 명예 안아줘요** 🌟
