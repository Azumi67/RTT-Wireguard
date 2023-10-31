![R (2)](https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/a064577c-9302-4f43-b3bf-3d4f84245a6f)
نام پروژه : ریورس تانل RTT با لودبالانس برای وایرگارد
---------------------------------------------------------------
![lang](https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/627ecb66-0445-4c15-b2a0-59e02c7f7e09)
**زبان - Languages**

- [زبان English]
------------------------
![R (a2)](https://github.com/Azumi67/RTT-Wireguard/assets/119934376/3f64bfa8-3785-4a0b-beba-366b3cb73719)
**دسترسی سریع به اسکریپت**


- [کلیک - click](https://github.com/Azumi67/6TO4-PrivateIP/blob/main/README.md#%D8%A7%D8%B3%DA%A9%D8%B1%DB%8C%D9%BE%D8%AA-%D9%85%D9%86)
------------------------
![check](https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/13de8d36-dcfe-498b-9d99-440049c0cf14)
**امکانات**
 <div dir="rtl">&bull; ریورس تانل وایرگارد با استفاده از Native IPV6 و پرایوت ایپی</div>
 <div dir="rtl">&bull;امکان ایجاد پرایوت ایپی برای سرور خارج و ایران و استفاده از آن در ریورس تانل</div>
 <div dir="rtl">&bull; افزودن ایپی 6 native برای سرور خارج</div>
 <div dir="rtl">&bull; امکان استارت و استاپ تانل</div>
 <div dir="rtl">&bull; لود بالانس udp با چندین ایپی 6 خارج بر روی تک پورت</div>
 <div dir="rtl">&bull; پشتیبانی از amd64 و arm </div>
 

 ![R (6)](https://github.com/Azumi67/RTT-Wireguard/assets/119934376/6ff6f48d-4677-4cee-b138-db51d19fce79)  [تانل RTT -Radkesvat](https://github.com/radkesvat)

 
 ------------------------------------------------------
  
  ![6348248](https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/398f8b07-65be-472e-9821-631f7b70f783)
**آموزش**

 

لود بالانس -ریورس تانل - پرایوت ایپی
---------------------------------------

![green-dot-clipart-3](https://github.com/Azumi67/6TO4-PrivateIP/assets/119934376/902a2efa-f48f-4048-bc2a-5be12143bef3) **ساخت پرایوت ایپی سرور خارج**

 

 <p align="right">
  <img src="https://github.com/Azumi67/RTT-Wireguard/assets/119934376/bd974599-9dde-4377-9c06-480ebd7533ff" alt="Image" />
</p>
 <div dir="rtl">&bull;در این روش، از پرایوت ایپی برای ارتباط با تانل و از ایپی 6 NATIVE برای لودبالانس استفاده خواهیم کرد  </div>
  <div dir="rtl">&bull; برای ساخت پرایوت ایپی از سرور خارج شروع نمایید</div>
   <div dir="rtl">&bull;ایپی 4 سرور ایران و خارج را وارد نمایید </div>
    <div dir="rtl">&bull; تعداد ایپی پرایوت مورد نیاز خود را وارد نمایید</div>


----------------------

![green-dot-clipart-3](https://github.com/Azumi67/6TO4-PrivateIP/assets/119934376/49000de2-53b6-4c5c-888d-f1f397d77b92)**ساخت پرایوت ایپی سرور ایران**


<p align="right">
  <img src="https://github.com/Azumi67/RTT-Wireguard/assets/119934376/a331964f-acb1-4783-9f56-776b4cda0d74" alt="Image" />
</p>
 <div dir="rtl">&bull; برای سرور ایران هم مانند سرور خارج، پرایوت ایپی میسازیم</div>
 <div dir="rtl">&bull; ایپی 4 سرور ایران و خارج را وارد می کنید</div>
   <div dir="rtl">&bull; تعداد ایپی پرایوتی که میخواهید را وارد نمایید</div>

--------------------------------------
![green-dot-clipart-3](https://github.com/Azumi67/6TO4-PrivateIP/assets/119934376/c14c77ec-dc4e-4c8a-bdc2-4dc4e42a1815)**ریورس تانل سرور ایران - PRIVATE IP**


<p align="right">
  <img src="https://github.com/Azumi67/RTT-Wireguard/assets/119934376/5ce74f8f-e0ba-496b-a271-217775032194" alt="Image" />
</p>
 <div dir="rtl">&bull; ریورس تانل را از سرور ایران شروع کنید</div>
  <div dir="rtl">&bull; تعداد ایپی 6 NATIVE خارج خود را وارد نمایید. به طور مثال من دو ایپی 6 خارج را برای لود بالانس وارد میکنم</div>
   <div dir="rtl">&bull; پورت تانل را 443 قراردهید و پسورد تانل خود را وارد نمایید</div>
    <div dir="rtl">&bull; SNI موردنظر خود را وارد نمایید</div>
     <div dir="rtl">&bull; مقدار زمان مورد نظر خود را برای ریستارت سرویس تانل، وارد نمایید</div>
       <div dir="rtl">&bull; ایپی 6 های NATIVE خارج خود را به ترتیب وارد نمایید. میتوانید تعداد ایپی 6 NATIVE خارج خود را افزایش دهید.</div>


---------------------------------


![green-dot-clipart-3](https://github.com/Azumi67/6TO4-PrivateIP/assets/119934376/2c1ae043-4bc5-4738-b1d4-6951c8fecbdc)**ریورس تانل سرور خارج - PTIVATE IP**



<p align="right">
  <img src="https://github.com/Azumi67/RTT-Wireguard/assets/119934376/6ad68c36-3a08-4f03-ae79-eeecdec681b2" alt="Image" />
</p>

<div dir="rtl">&bull; ایپی پرایوت ایران را وارد نمایید</div>
<div dir="rtl">&bull; پورت تانل 443 را قرار میدهیم و پسورد تانل را وارد می کنیم</div>
  <div dir="rtl">&bull; SNI ای که در سرور ایران قرار دادیم هم در سرور خارج جای گذاری میکنیم</div>
   <div dir="rtl">&bull; پورت هم اکنون وایرگارد سرور خارج را وارد میکنید. به طور مثال 50820</div>
      <div dir="rtl">&bull; ENDOINT وایرگارد شما به این صورت خواهد بود : IRAN-IPV4:443</div>
 
------------------------------------------------------------------------------
لود بالانس - NATIVE IPV6 - ریورس تانل
----------------------------
![green-dot-clipart-3](https://github.com/Azumi67/6TO4-PrivateIP/assets/119934376/2c1ae043-4bc5-4738-b1d4-6951c8fecbdc)**ریورس تانل سرور خارج -افزودن ایپی 6 NATIVE**


<p align="right">
  <img src="https://github.com/Azumi67/RTT-Wireguard/assets/119934376/cea0dbbd-b1cf-47bb-a0a5-c1e02e34a8a3" alt="Image" />
</p>

 <div dir="rtl">&bull; افزودن ایپی 6 NATIVE . [درسرور دیحیتال اوشن تست شده] </div>
  <div dir="rtl">&bull; اگر به هر صورت برای سرور خارج شما کار نکرد، لطفا به صورت دستی اضافه نمایید یا از اسکریپت اپیران که در قسمت اسکریپت های کارامد قرارداده ام، استفاده نمایید.</div>


---------------------------------------------------------------------------

![green-dot-clipart-3](https://github.com/Azumi67/6TO4-PrivateIP/assets/119934376/2e325267-240d-4e20-ba5a-ff408331d5a0)**ریورس تانل سرور ایران - NATIVE IPV6**


  <p align="right">
  <img src="https://github.com/Azumi67/RTT-Wireguard/assets/119934376/5bf16fd6-fd7c-4832-a2b8-18f6490546d1" alt="Image" />
</p>
<div dir="rtl">&bull; تعداد ایپی 6 NATIVE خارج خود را انتخاب نمایید. این ایپی ها برای لود بالانس استفاده میشود. دقت نمایید که لود بالانس با استفاده از ایپی 6 های متفاوت بر روی یک سرور خارج انجام میشود </div>
   <div dir="rtl">&bull; پورت تانل را 443 قرار میدهیم و پسورد تانل را هم وارد مینماییم</div>
    <div dir="rtl">&bull; SNI مورد نظر خود را وارد نمایید</div>
     <div dir="rtl">&bull; ایپی 6 های NATIVE خارج را به ترتیب وارد مینماییم. دقت کنید این ایپی 6 ها متعلق به یک سرور خارج میباشد</div>


-------------------------------
![green-dot-clipart-3](https://github.com/Azumi67/6TO4-PrivateIP/assets/119934376/2e325267-240d-4e20-ba5a-ff408331d5a0)**ریورس تانل سرور خارج - NATIVE IPV6**

  <p align="right">
  <img src="https://github.com/Azumi67/RTT-Wireguard/assets/119934376/008f39d1-15e6-4039-9f44-0afcc3cbd06b" alt="Image" />
</p>
<div dir="rtl">&bull;ایپی 6 NATIVE سرور ایران را وارد میکنیم. اگر ایپی 6 NATIVE ندارید از تانل بروکر یا پرایوت ایپی استفاده نمایید  </div>
   <div dir="rtl">&bull; پورت تانل و پسورد تانل و همچنین SNI را مانند سرور ایران، وارد میکنیم </div>
    <div dir="rtl">&bull; پورت هم اکنون وایرگارد سرور خارج را وارد نمایید. به طور مثال 50820</div>
     <div dir="rtl">&bull; زمان ریست سرویس را وارد نمایید.</div>
     <div dir="rtl">&bull; ENDPOINT شما در وایرگارد به این صورت خواهد بود : IRAN-IPV4:443</div>
    

----------------------------------------------------



**اسکرین شات**
<details>
  <summary align="right">Click to reveal image</summary>
  
  <p align="right">
    <img src="https://github.com/Azumi67/RTT-Wireguard/assets/119934376/53a218e3-3fff-4255-a164-e4c0ddb9b03b" alt="menu screen" />
  </p>
</details>


------------------------------------------
![scri](https://github.com/Azumi67/FRP-V2ray-Loadbalance/assets/119934376/cbfb72ac-eff1-46df-b5e5-a3930a4a6651)
**اسکریپت های کارآمد :**


 <div dir="rtl">&bull; میتوانید از اسکریپت opiran vps optimizer یا هر اسکریپت دیگری استفاده نمایید.</div>
 
 
```
apt install curl -y && bash <(curl -s https://raw.githubusercontent.com/opiran-club/VPS-Optimizer/main/optimizer.sh --ipv4)
```

<div dir="rtl">&bull; اضافه کردن ایپی 6 اضافه</div>
 
  
```
bash <(curl -s -L https://raw.githubusercontent.com/opiran-club/softether/main/opiran-seth)
```
-----------------------------------------------------
![R (a2)](https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/716fd45e-635c-4796-b8cf-856024e5b2b2)
**اسکریپت من**
----------------


```
apt install curl -y && bash <(curl -Ls https://raw.githubusercontent.com/Azumi67/RTT-Wireguard/main/rtt.sh --ipv4)
```


---------------------------------------------
![R (7)](https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/42c09cbb-2690-4343-963a-5deca12218c1)
**تلگرام** 
![R (6)](https://github.com/Azumi67/FRP-V2ray-Loadbalance/assets/119934376/f81bf6e1-cfed-4e24-b944-236f5c0b15d3) [اپیران](https://github.com/opiran-club)

---------------------------------
![R23 (1)](https://github.com/Azumi67/FRP-V2ray-Loadbalance/assets/119934376/18d12405-d354-48ac-9084-fff98d61d91c)
**سورس ها**

![R (6)](https://github.com/Azumi67/RTT-Wireguard/assets/119934376/773f19ca-a44d-41b2-b5c8-572631361268)[سورس  RTT - RADKESVAT]([https://github.com/opiran-club](https://github.com/radkesvat)

![R (9)](https://github.com/Azumi67/FRP-V2ray-Loadbalance/assets/119934376/33388f7b-f1ab-4847-9e9b-e8b39d75deaa) [سورس های OPIRAN](https://github.com/opiran-club)


-----------------------------------------------------

![youtube-131994968075841675](https://github.com/Azumi67/FRP-V2ray-Loadbalance/assets/119934376/24202a92-aff2-4079-a6c2-9db14cd0ecd1)
**ویدیوی آموزش**

-----------------------------------------


