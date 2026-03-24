# 🛠️ My Dotfiles (Multi-OS Support)

우분투(Debian 계열)와 로키(Red Hat 계열) 환경을 모두 지원하는 자동화 서버 초기화 스크립트입니다. 
`init.sh`를 통해 필요한 도구만 골라서 설치할 수 있습니다.

---

## 🚀 사용 방법 (Usage)

```bash
chmod +x init.sh scripts/*.sh

sudo ./init.sh --docker --nvim --netdata

📌 가용 옵션 (Options)
| 옵션명 | 설명 | 비고 |
|---|---|---|
| --docker | Docker Engine & Compose 설치 | 현재 사용자 docker 그룹 추가 포함 |
| --nvim | Neovim (Unstable), FZF, Lazygit 설치 | Node.js, Rust 빌드 환경 포함 |
| --ruby | rbenv 기반 최신 Ruby & Rails 설치 | 최신 안정 버전 자동 감지 |
| --netdata | Netdata (Headless Collector) 설정 | 전용 API KEY 자동 생성 |
📂 프로젝트 구조 (Structure)
 * init.sh: 부모 스크립트. OS를 감지하고 각 하위 스크립트로 인자를 전달합니다.
 * scripts/: 실제 설치 로직이 담긴 자식 스크립트들입니다.
   * docker.sh: 도커 저장소 설정 및 엔진 설치
   * nvim.sh: 개발 환경 및 에디터 설정
   * ruby.sh: rbenv 및 루비 빌드
   * netdata.sh: 모니터링 에이전트 설정
⚠️ 주의 사항
 * 설치가 끝난 후 source ~/.bashrc를 입력하거나, 터미널을 다시 시작해야 환경 변수가 정상 반영됩니다.
 * Docker 그룹 권한 적용을 위해 재로그인이 필요할 수 있습니다.
