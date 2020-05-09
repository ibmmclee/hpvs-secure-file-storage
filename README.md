# HPVS를 이용한 파일 공유 컨테이너 프로그램의 보안 강화 데모 튜토리얼
이 샘플 프로그램은 그룹 사용자들이 파일을 공용 스토리지 풀에 업로드 하고 그룹내의 다른 사용자들이 접근 가능하도록 공유 링크를 제공하는 프로그램 입니다. 이 샘플 프로그램은 [Node.js®](https://nodejs.org/) 로 작성하여 [IBM 클라우드™](https://cloud.ibm.com/)의 HPVS(Hyper Protect Virtual Server service) 에 전개 됩니다. 이 프로그램은 보안을 강화하기 위해 IBM 클라우드 서비스의 보안 관련된 몇 가지의 서비스와 특징(features)들을 할용 합니다.
![Architecture](docs/images/Architecture.png)


Vue.js 라는 예제 프로그램은 하이퍼 프로텍트 버츄얼 서버에서 동작하는 Node.js 프로그램의 안전한 루틴을 호출하는 프로그램입니다.

    1. 사용자는 데모 프로그램을 실행하고 인증 프로세스를 밟을 할 수 있도록 로그인 요구를 합니다.
    2. App ID 는 로그인 위젯을 보여주면서 인증 프로세스를 시작 합니다. 
    3. 사용자는 사용자 이름과 비밀번호를 입력하고, 계정조회가 완료 되면 데모 프로그램으로 넘어가게 됩니다.
    4. 프로그램은 클라우드 오브젝트 스토리지 (COS) 의 버킷 을 읽고 쓰기를 합니다. 
    5. 프로그램은 COS 버킷에 저장된 정보의 메타데이터를 읽고 쓰기위한 테이블을 Hyper Protect DBaaS for PostgreSQL 에 저장합니다. 
    6. Hyper Protect Crypto Services 는 COS 버킷과 PostgreSQL 데이터베이스에 저장된 모든 데이터를 암호와 합니다. 신원증명(Identity)와 접근관리는 가상서버가 데이터에 접근할 수 있도록 하는  위한 암호화 키를 사용하는데 이용됩니다.

## 비용
이 데모 프로그램을 실행하려면 반드시 종량과금제(Pay-as-You-Go account IBM Cloud™) 으로 해야 합니다. 대부분의 서비스는 Lite 계정으로 무료 사용 가능하지만 HPVS 와 같은 서비스를 30일간 무료로 사용하려면 Pay-as-You-Go 계정이 필요 합니다.

또한 일부 서비스는 무료사용에 제한이 있습니다 예를들어 App ID, Hyper Protect Virtual Server, Hyper Protect DBaaS 는 30일간 무료 사용 후 자동적으로 서비스가 지워집니다.

만약 구독 계정을 사용하신다면, 비용이 나가는 서비스는 사용하지 않을 경우 이를 삭제 해 주세요.

### 전제조건
다른 서비스를 생성하기 전에 [사용 가능한 지역](https://cloud.ibm.com/docs/services/hs-crypto?topic=hs-crypto-regions) 먼저 검토 해 주세요.

- App ID 인스턴스를 생성하기 위해  [시작하기 튜토리얼](https://cloud.ibm.com/docs/services/appid?topic=appid-getting-started#create) 섹션에서 "서비스 인스턴스 작성" 부분을 따라 해 주세요. 인스런스가 생성되면 다음의 절차를 따라해 주면 됩니다.

- 하이퍼 프로텍트 크립토 서비스 인스턴스를 만들기 위해 [IBM Cloud Hyper Protect Crypto Services 시작하기](https://cloud.ibm.com/docs/services/hs-crypto?topic=hs-crypto-get-started) 토픽의 절차를 따라 하세요. 그리고 [서비스 인스턴스 초기화 시작하기](https://cloud.ibm.com/docs/services/hs-crypto?topic=hs-crypto-initialize-hsm) 에 있는 절차를 따라 하세요.

- 하이퍼 프로텍트 버추얼 서버의 인스턴스를 만들기 위해 [가상 서버 프로비저닝](https://cloud.ibm.com/docs/services/hp-virtual-servers?topic=hp-virtual-servers-provision) 토픽의 절차를 따라 하세요.  단지 이 리파지토리의 코드만 테스트 하려면 무료인 Lite(Free) 플랜의 인스턴스를 생성해 주세요.

- 오브젝트 스토리지 인스턴스 생성을 위해 [스토리지 프로비저닝](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-provision) 토픽의 절차를 따라 하세요. 그리 하래 섹션[서비스 권한 부여]을 참고로 하셔서 오브젝트 스토리지 인스턴스가 하이퍼 프로텍트 크립토 서비스를 사룡할 수 있는 권한을 가지도록 설정해 주세요. 그리고 [버킷 작성](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-encryption#create-a-bucket) 을 해 주세요.

<!-- - Follow the steps outlined in the [Provision an instance of the IBM Cloud Activity Tracker with LogDNA service](https://cloud.ibm.com/docs/services/Activity-Tracker-with-LogDNA?topic=logdnaat-getting-started#gs_step1) topic to create a an instance of Activity Tracker and make sure to [configure platform services logs](https://cloud.ibm.com/docs/services/Log-Analysis-with-LogDNA?topic=LogDNA-config_svc_logs). -->

- Hyper Protect DBaaS for PostgreSQL 의 인스턴스를 생성하기 위해 [서비스 인스턴스 작성](https://cloud.ibm.com/docs/services/hyper-protect-dbaas-for-postgresql?topic=hyper-protect-dbaas-for-postgresql-dbaas_webui_service#dbaas_webui_create_service) 섹션에 나와있는 절차를 따라해 주세요. 여기서 중요한 것은 반드시 데이터베이스 관리자 이름을 secure-file-storage-metadata 으로 해 주세요. 만약 다른 이름으로 하면 데모 프로그램 실행시 에러가 나옵니다. 단지 이 리파지토리의 코드만 테스트 하려면 무료인 Lite(Free) 플랜의 인스턴스를 생성해 주셔도 좋습니다.

  > 주의: 이 리파지토리에 있는 프로그램은 Hyper Protect DBaaS for MongoDB 도 지원 합니다. 그러나 현재의 설명은 PostgreSQL 위주로 되어 있습니다.

## 서비스 권한 부여

클라우드 오브젝트 스토리지 버켓이나 PostgreSQL 에 저장된 데이터를 암호와 하기 위해 다음의 절차에 따라 Hyper Protect Crypto Services 를 추가해 주세요. 

   1. 클라우드 콘솔에서  관리 > 엑세스 (IAM) > 권한  의 메뉴를 따라 가면서 권한관리 페이지로 들어 오세요.
   2. 작성 버튼을 누르시고 서비스권한 부여 페이지로 들어 가세요. 
   3. 소스 서비스 메뉴에서 Cloud Object Storage 를 선택 해 주세요.
   4. 소스 서비스 인스턴스 메뉴가 생기면 여기에서 기 생성한 오브젝트 스토리지 인스턴스를 선택 해 주세요.  (주의: 오브젝트 스토리지 서비스 인스턴스를 선택 하려면 사전에 미리 오브젝트 스토리지 서비스 인스턴스를 생성해야 합니다.)
   5. 대상 서비스 메뉴에서  Hyper Protect Crypto Services 를 선택 해 주세요. 
   6. 대상 서비스 인스턴스 메뉴가 나오면 오른쪽의 모든 인스턴스 에서 기 생성한 Hyper Protect Crypto Service 인스턴스를 선택 해 주세요.
      그리고 서비스 엑세스 권한 에서 Reader 를 선택해 주세요. 
   7. 권한 부여 버튼을 클릭 해 주세요.
   8. Hyper Protect DBaaS for PostgreSQL 에 대해서도 같은 절차를 실해 해 주세요 다만 3,4번 에서 Hyper Protect DBaaS for PostgreSQL 를 선택 하시면 됩니다. 

## 시작하기

    1. 이 리파지토리의 소스코스를 Clone 합니다. 
    2. 터미널 윈도우에서  hpvs-secure-file-storage 디렉토리로 변경 합니다.
    3. secrets-template 디렉토리를 secrets 라는 디렉토리에 복사를 합니다

## 데모 프로그램을 위한 설정 

    이 프로그램은 데모용이라 HTTPS 구성되어 있지 않습니다. [클라우드 애플리케이션에 엔드 투 엔드 보안 적용](https://cloud.ibm.com/docs/tutorials?topic=solution-tutorials-cloud-e2e-security) 을 보시고 어플리케이션에 관한 엔드 투 엔드에 보안을 적용할 수 있습니다. 

    1.  클라우드 콘솔의 리소스 목록의 서비스에서 기 생성한 Hyper Protect Virtual Server 인스턴스를 클리 해 주세요.
        관리 탭에서 이 인스턴스의 공용 IP 주소를 복사 해 주세요. 

    2.  리소스 목록에서 기 생성한 App ID 서비스를 클릭 해 주세요.
        인증관리 메뉴에서  Authentication Settings 를 선택 해 주세요
        Add web redirect URLs 에서  좀 전에 복사한 공용 IP 를 붙여 넣게 해서  http://public_ip_address_of_virtual_server/appid_callback 를 완성 하고 추가 해 주세요
        왼쪽 패널에서 애플리케이션 을 선택 하고 Add application 버튼을 클릭 해 주세요.
        web application 의 이름을 입력 하세요, 예를들어 hvps-secure-file-storage , 그리고 type 으로 Regular web application 을 선택 한 후 save 를 클릭 해 주세요.
        어플리케이션 이름 왼쪽에 있는 v 를 클릭하여 뷰를 확장하고 그 속에 있는 JSON object 를 복사 해 주세요.
        이전에 만든 secrets 이란 디렉토리 아래에 appid.json 파일을 만든 후편집하여 위에서 복사한 내용을 붙여 넣어 주세요. 

    3.  리소스 목록에서 오브젝트 스토리지 인스턴스를 클릭해 주세요. 
        사비스 인증 정보에서 새인증정보를 클릭 해 주세요. 
        이름을 입력하고 역할을 Writer 로 해 주세요.
        서비스 ID 선택에서 그냥 자동 생성으로 남겨 두시고, 
        고급 옵션에서 HMAC 인증정보 포함을 설정 해 주세요. {"HMAC":true}. 이 값은 필요한 URL을 생성할 때 사용 됩니다. 
        추가 를 클릭 해 주세요.
        크레덴셜 뷰를 확장해서 크레덴셜을 클립보드에 복사 해 주세요. 
        이전에 만든 secrets 이란 디렉토리 아래에 cos.json 이란 파일을 만들고 편집하여 클립보드에 복사한 내용을 붙여 넣기 합니다.

    버킷 작성
		왼쪽 메뉴에서 버킷을 선택 한 후 오른쪽의 버킷 작성 버튼을 클릭 해 주세요.
		커스터마이즈 버킷을 선택 해 주세요.
        고유 버킷 이름에  <your-initials>-secure-file-upload 와 같은 고유한 이름을 작성해 주세요. 
        복원성에 Regional 을 선택 해 주세요.
        위치는 secure-file-storage 사비스를 작성한 곳과 같은 위치를 선택 해 주세요.
        스토리지 클래스는 표준으로 선택 해 주세요.
        키 관리 서비스에서 Hyper Protect Crypto Services 를 선택해 주세요.
        작성한 Hyper Protect Crypto Services service 인스턴스를 선택 해 주세요.
        드롭다운 메뉴에서 기 작성한 키를 선택 해 주세요.
        버킷 작성을 클릭 해 주세요.

    4.  서비스 목록에서 Hyper Protect DBaaS 인스턴스를 클릭 하세요.
        개요 페이지에서 CA 파일을 다운로드 하시고 cert.pem 으로 이름을 바꾸어서 secrets 디렉토리에 복사 해 주세요.
        개요 탭과 사용자 탭에 나와 있는 정보를 이용해 아래와 같이 config.json 파일의 placeholder 글자 부분을 업데이트 해 주세요.

		config.json 편집:
        postgresql properties 에서 placeholder 글자를 [서비스 인스턴스에 대한 자세한 정보 보기](https://cloud.ibm.com/docs/services/hyper-protect-dbaas-for-postgresql?topic=hyper-protect-dbaas-for-postgresql-dbaas_webui_service#dbaas_webui_manage_service) 의 설명에 따라 적절한 값으로 치환 해 주세요.
        appid properties 에서 placeholder 글자를 실제 app 이 실행될 서버의 url/host 주소로 치환해 주세요. 
		예를들어 http://public_ip_address_of_virtual_server/appid_callback.

## 데모 프로그램 전개

    터미널 윈도우에서 hpvs-secure-file-storage directory 하나 위의 디렉토리에서 다음의 명령어를 수행해서  Hyper Protect Virtual Server 인스턴스로 파일들을 복사 해 주세요:
    scp -r ./hpvs-secure-file-storage root@placeholder_ip_address:/

    다음과 같이 SSH 로  your Hyper Protect Virtual Server 인스턴스에 연결 해 주세요.
    ssh root@public_ip_address_of_virtual_server

    hpvs-secure-file-storage 디렉토리로 변경 합니다.
        scritps 디렉토리 아래의 모든 파일을 실행가능 파일로 만듭니다. : chmod +x scripts/*.sh.
        hpvs-secure-file-storage 디렉토리에서 다음의 스크립트를 셀행 합니다 : scripts/app-deploy.sh, 만약 에러가 발생하면 hpvs-secure-file-storage.<datetime>.log 파일로 로그가 쌓입니다. 내용을 보시고 에러의 원인을 찾아 보세요.

    프로그램이 잘 실행되는지 알아보려면 pm2 status 라는 명령을 실행 하십시오. 그리고 에러가 없는지 pm2 logs 명령어로 로그를 확인 해 보거나 logs 디렉토리에 쌓인 로그 파일을 조사 해 보세요. 

    브라우저를 사용해서 다음의 URL로 데모프로그램을 접속 해 보세요 : http://public_ip_address_of_virtual_server/

## 데모 프로그램의 개요 및 소스코드 구조

![app-view](docs/images/app-view.png)


    1. 사용자는 Hyper Protect Virtual Server 의 공용 IP 로 데모 프로그램을 접속할 수 있습니다. 

      > 프로덕션을 위해서는 TLS/로드 밸런스를 추가 할 수 있습니다. [Cloud Internet Service](https://cloud.ibm.com/catalog/services/internet-services) 도 고려 해 보세요. [여러 지역에서 웹 애플리케이션 보안](https://cloud.ibm.com/docs/tutorials?topic=solution-tutorials-multi-region-webapp#multi-region-webapp) 튜토리얼을 보시고 서비스를 생성하고 구성해 보세요. 

    2. [App ID](https://cloud.ibm.com/catalog/services/AppID)는 프로그램을 보호하고 사용자를 인증화면으로 리다이렉션 해 줍니다. 
    3. 프로그램은 [Hyper Protect Virtual Server](https://cloud.ibm.com/catalog/services/hyper-protect-virtual-server)에서 수행이 됩니다.
    4. 사용자가 옵로드한 파일들은 [Cloud Object Storage](https://cloud.ibm.com/catalog/services/cloud-object-storage)에 저장이 됩니다. 

    5. Node.JS 어플리케이션과 관련되는 작업은 모두 서버의 logs 디렉토리에 저장이 됩니다. 예를들어  access.log 는 어플리케이션의 경로에 관한 로그를 저장합니다.
	   시스템과 에러 로그도 저장이 됩니다. 
	   
| 파일 | 설명 |
| ---- | ----------- |
|[app.js](app.js)|어플리케이션 구현|
|[routes/appid.js](routes/appid.js)|App ID 인증 루틴의 구현|
|[routes/files.js](routes/files.js)|파일 처리를 위한 CRUD 작업 구현|
|[utils/](utils/)|어플리케이션의 접근과 시스템/에러의 로깅을 위한 winston 모듈의 구현|
|[database/](database/)|데이터베이스의 자료를 저장 하거나 조회할 때 사용되는 (PostgreSQL and MongoDB) 와 관련된 코드|
|[public/](public/)|Node.js 백 엔드 프로그램과 인터페이스하는 Vue.js 프로그램을 포함  |
|[secrets-template](secrets-template)| `secrets` 디렉토리에 복사될 데이터베이스, 클라우드, 오브켁트 스토리지 구성 파일들,  `config.json` 파일은  PostgreSQL, App ID, 클라우드 오브젝트  스토리지 서비스 들의 위치를 포함합니다.|
|[scripts/app-deploy.sh](scripts/app-deploy.sh)|는 셸 스크립트 입니다. 가상서버의 어플리케이션과 Node.js 어플리케이션이 서비스로 수행하기 위한 디펜던시들을 설치해 줍니다|


## 서비스

IBM Cloud services featured: 

  - [App ID](https://cloud.ibm.com/catalog/services/AppID): App ID 는 개발자들이 웹과 모바일 웹의 인증절차를 몇줄 코드로 쉽게 구현 할 수 있게 하고, 클라우드 네이티브 어플리케이션을 안전하게 보호 합니다. 사용자에게 당신의 어플리케이션에 사인 인 하게 함으로써 앱 선호도나 퍼블릭 소셜 프로파일 같은 고객자료를 저장할 수 있고 이후 이 자료를 레버리지 하여 앱 내에 고객의 경험을 커스터마지즈 할 수 있습니다.  

  <!-- - [Cloud Activity Tracker with LogDNA](https://cloud.ibm.com/catalog/services/logdnaat): Activity Tracker records user-initiated activities that change the state of a service in IBM Cloud. You can use this service to investigate abnormal activity and critical actions and to comply with regulatory audit requirements. -->

  - [클라우드 오브젝트 스토리지](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-about-cloud-object-storage): IBM Cloud™ Object 오브젝트 스토리지는 실제적으로 무한한 량의 자료를 간단하고 저렴하게 저장할 수 있습니다. IBM 클라우드 오브젝트 스토리지에 저장된 정보는 암호화되고 여러 위치에 분산되어 저장 됩니다. 그리고 최신의 Rest API 를 사용하는 HTTP 와 같은 일반적인 프로코콜을 사용합니다.  당신이 관리하는 루트키로 사용하되는 Hyper Protect Crypto 서비스는 자료를 Rest 상태에서 암호화 됩니다.
  
  - [Hyper Protect Crypto Services](https://cloud.ibm.com/docs/services/hs-crypto?topic=hs-crypto-overview): IBM Cloud™ Hyper Protect Crypto 서비스는 발전된 클라우드 키 관리 서비스와 하드웨어 보안 모듈 (HSM) 으로 업계 최고 보안 수준으로 데이터를 암호화 합니다. Hyper Protect Crypto 서비스는 사용자가 통제하는 전용 HSM 입니다. 클라우드 관리자일지라도 전혀 접근 할 수 없습니다. 이 서비스는 FIPS 140-2 레벨 4 인증을 받은 하드웨어 입니다. 

  - [Hyper Protect DBaaS](https://cloud.ibm.com/docs/services/hyper-protect-dbaas-for-postgresql?topic=hyper-protect-dbaas-for-postgresql-overview): IBM Cloud™ Hyper Protect DBaaS 는 기업용 업무관련 민감한 데이터를 위한 높은 수준의 데이터베이스 환경을 제공 합니다. IBM LinuxONE 기술로 만들어진 IBM Cloud™ Hyper Protect DBaaS는  내장된 암호화 기능과 위조방지 기능은 데이터를 정지 및 이동구간에서도 암호화 합니다. PostgreSQL 과 MongoDB 모두를 지원 합니다.

  - [Hyper Protect Virtual Server](https://cloud.ibm.com/docs/services/hp-virtual-servers?topic=hp-virtual-servers-overview): Hyper Protect Virtual Server 는 리눅스 어플리케이션이 실행되는 높은 보안 수준의 가상 서비 입니다. 이는 융통성 있고 확장 가능한 프레임워크를 제공 하여 사용자들이 빠르고 쉽게 프로비저닝 하고 관리 할 수 있습니다. 

  - [Cloud Internet Service](https://cloud.ibm.com/catalog/services/internet-services)(optional): 클라우드 인터넷 서비스(CIS)는 인터넷을 접하는 어플리케이션, 웹 사이트, 및 165개 이상의 Cloudflare 데이터센터 서비스 (PoPs) 에게 신뢰성, 성능과 보안성을 제공 합니다. 이는 도메인 네임서비스와(DNS), 글로벌 로드밸런스(GLB), 분산 디도스공격(DDoS) 보호 , 웹 어플리케이션 방화벽(WAF), Transport Layer Security (TLS), 속도 제한, 스마트 라우팅과 캐싱 기능을 포함 합니다. 만약 어플리케이션을 여러개의 지역에 분산하여 전개할 경우에 로드밸런싱을 위해 CIS를 추가 할 수 있흡니다.

    다음 그림의 예는 하나 또는 여러개의 HPVS 인스턴스 앞단에서 GLB 역할은 하는 CIS 를 포함합니다. 

      ![Architecture-mzr](docs/images/Architecture-mzr.png)
