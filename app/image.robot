
*** Settings ***
Library  imageproc.py

*** Variables ***
${before}     /opt/app/screenshots/e1.jpg
${during}      /opt/app/screenshots/e2.jpg
${after}      /opt/app/screenshots/e1.jpg

@{naughty_list}  crash  error  failed  closed  sorry  stopped  stopping  snap  unexpected  exception  fail  fault  isn't responding  allow  deny  only this time  while using the app  change your device settings  send feedback
@{tls_naughty_list}  unable  sorry  snap  exception  error  fail  ssl  connection  ERR_  SSL_  DNS_  can't be reached  back to safety  not private

*** Test Cases ***
Look for browse errors
  Look for text in image  ${during}  @{TLS_naughty_list}

Look for popup
  Check images have not changed  ${before}  ${after}  0.98

Check for error messages in image
  Look for text in image  ${during}  @{naughty_list}

*** Keywords ***
Check images have not changed
   [Arguments]  ${image1}  ${image2}  ${Allowed_Threshold}

   ${OUTPUT}=  get image similarity  img1=${image1}  img2=${image2}
   ${RESULT}=  Evaluate  ${OUTPUT} > ${Allowed_Threshold}
   Should be True  ${RESULT}

Look for text in image
   [Arguments]  ${Test_Image_Path}  @{list of words}
   ${text}=  fetch text in image  ${Test_Image_Path}
   ${length} = 	Get Length  ${text}
   Should Be True 	${length} > 1  Should be some text in the image
   Should Not Contain Any  ${text}  @{list of words}
