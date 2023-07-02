# MC3-Team14-FutureStarz
Apple Developer Academy @ POSTECH (MC3 Team FutureStarz)

## 📝 코드 컨벤션
1. **Class / Struct** 정의
    - Class / Struct의 정의는 UpperCamelCase를 사용합니다.
    ```swift
    class FindIdViewModel: ObservableObject { ... }
    struct FindIdModel: Codable { ... }
    ```
2. **변수 및 함수**정의
    - 변수와 함수의 정의는 lowerCamelCase를 사용합니다.
    ```swift
    func getFacilities(userUUID: String) { ... }
    var facilityName: String = ""
    ```
3. **주석**활용
    - View는 **// - MARK :** 주석을 통해 영역을 구분합니다.
  

<br>

> 커밋 컨벤션
```
[CHORE] 코드 수정, 내부 파일 수정, 주석
[FEAT] 새로운 기능 구현
[ADD] Feat 이외의 부수적인 코드 추가, 라이브러리 추가, 새로운 파일 생성 시, 에셋 추가
[FIX] 버그, 오류 해결
[DEL] 쓸모없는 코드 삭제
[DOCS] README나 WIKI 등의 문서 개정
[MOVE] 프로젝트 내 파일이나 코드의 이동
[RENAME] 파일 이름 변경이 있을 때 사용합니다
[REFACTOR] 전면 수정이 있을 때 사용합니다
[INIT] 프로젝트 생성
```
