# PRD — Kamrai POS (ระบบขายหน้าร้านสำหรับธุรกิจอาหาร)

> เวอร์ชัน 1.0 | วันที่ 10 เมษายน 2569  
> เอกสารนี้สรุปภาพรวม ฟีเจอร์ และสิ่งที่ Front-end ต้องทำทั้งหมด โดยอ้างอิงจาก Database Schema `kamrai POS.sql`

---

## 1. ภาพรวมของระบบ

Kamrai POS คือระบบจุดขาย (Point of Sale) สำหรับ **ธุรกิจร้านอาหาร** ที่รองรับหลายรูปแบบ ได้แก่ ร้านอาหาร A-La-Carte, ร้าน Set เมนู และร้านบุฟเฟต์ โดยมีโครงสร้างเป็น **Multi-Company / Multi-Branch** รองรับการเปิดหลายสาขาภายใต้บริษัทเดียวกัน และมี **ศูนย์กลาง (Center)** สำหรับบริหารลูกค้าและพอยต์ข้ามสาขา

### โครงสร้างองค์กร

```
Center (ส่วนกลาง)
  └── Company (บริษัท/ร้าน)
        └── Branch (สาขา)
              └── Users (พนักงาน/แคชเชียร์)
```

---

## 2. ผู้ใช้งานหลัก (User Roles)

| Role | คำอธิบาย |
|---|---|
| **Center Admin** | ผู้ดูแลระบบส่วนกลาง จัดการบริษัท / ลูกค้า / พอยต์ |
| **Company Owner** | เจ้าของร้าน ดูข้อมูลทุกสาขา ตั้งค่าเมนู / โปรโมชัน |
| **Branch Manager** | ผู้จัดการสาขา ดูรายงาน ตั้งค่าสาขา |
| **Cashier / Staff** | พนักงานแคชเชียร์ เปิดบิล รับออเดอร์ ชำระเงิน |

---

## 3. โมดูลหลักของระบบ

### 3.1 Authentication & Settings

**สิ่งที่ Front-end ต้องทำ**
- หน้า Login (username / password)
- เลือกสาขาที่จะทำงาน (กรณีผู้ใช้มีหลายสาขา)
- บันทึก session และ token สำหรับเรียก API
- ตั้งค่าอุปกรณ์ส่งออก (เครื่องพิมพ์, ลิ้นชักเงิน) ต่อสาขา

**Tables ที่เกี่ยวข้อง:** `users`, `companys`, `branchs`, `configs`, `output_devices`

---

### 3.2 จัดการเมนูอาหาร (Menu Management)

ระบบเมนูมี **3 ระดับ** ซ้อนกัน:

```
menu_buffets (แพ็กเกจ/ประเภท: A-La-Carte | SET | Buffet)
  └── menu_sets (ชุดเมนู / กลุ่มอาหาร เช่น "กับข้าว", "ของหวาน")
        └── menus (รายการอาหาร เช่น "ผัดกะเพราหมู")
              └── menu_options (ตัวเลือก เช่น ระดับความเผ็ด, ท็อปปิ้ง)
```

**ฟีเจอร์ที่ต้องทำ**
- CRUD แพ็กเกจ/เมนูบุฟเฟต์ (กำหนดราคา, พอยต์สะสม)
- CRUD ชุดเมนู (เชื่อมกับหมวดหมู่การแสดงผล และเครื่องพิมพ์ครัว)
- CRUD รายการอาหาร (ไทย/อังกฤษ)
- เพิ่ม Options ต่อรายการอาหาร:
  - **Addon** — เพิ่มท็อปปิ้ง (มีราคา)
  - **Multi** — เลือกได้หลายตัวเลือก (กำหนด min/max)
  - **Text** — พิมพ์หมายเหตุอิสระ
- กำหนดว่าแพ็กเกจใดขายในสาขาใดบ้าง
- จัดการ **หมวดหมู่การแสดงผล** (display_categorys) สำหรับแยกพิมพ์ไปครัว

**Tables ที่เกี่ยวข้อง:** `menu_buffets`, `menu_buffet_packages`, `menu_Buffet_branchs`, `menu_sets`, `menus`, `menu_options`, `display_categorys`

---

### 3.3 จัดการโต๊ะ (Table Management)

**ฟีเจอร์ที่ต้องทำ**
- แสดงผัง Floor Plan โต๊ะแบ่งตามโซน (Zone)
- แสดงสถานะโต๊ะ: 🟢 ว่าง | 🔴 ไม่ว่าง | 🟡 กำลังทำความสะอาด
- คลิกโต๊ะเพื่อ: เปิดบิลใหม่ / ดูบิลปัจจุบัน / ย้ายโต๊ะ / รวมโต๊ะ
- สร้าง QR Code ประจำโต๊ะสำหรับให้ลูกค้าสั่งอาหารเอง (`table_order_token`)
- CRUD โซนและโต๊ะ (ชื่อ, ความจุ)

**Tables ที่เกี่ยวข้อง:** `dining_zone`, `dining_tables`

---

### 3.4 การรับออเดอร์ (Order Taking — หน้าหลัก POS)

นี่คือหน้าหลักของระบบที่พนักงานใช้งานมากที่สุด

**ฟีเจอร์ที่ต้องทำ**

#### เปิดบิล
- เลือกประเภทบิล: **Dine-In** (ทานที่ร้าน) | **Take Away** (กลับบ้าน) | **Delivery** (จัดส่ง)
- กรณี Dine-In: เลือกโต๊ะ และประเภท A-La-Carte หรือ Buffet
- เลือกช่องทางการสั่ง (Order Channel): WalkIn, Grab, LineMan, ShopeeFood ฯลฯ

#### รับออเดอร์
- แสดงรายการอาหารแบ่งตามหมวดหมู่
- กดเพิ่มรายการ → แสดง popup ตัวเลือก (Options) ถ้ามี
- แสดง Order List ฝั่งขวา (รายการที่เพิ่มแล้ว พร้อมจำนวนและราคา)
- สั่งพิมพ์ใบออเดอร์ไปครัว (ตามเครื่องพิมพ์ที่กำหนดต่อหมวดหมู่)
- ติดตามสถานะออเดอร์แต่ละรายการ: `ordered` → `served` → `cancelled`

**Tables ที่เกี่ยวข้อง:** `bills`, `bill_menu_buffets`, `bill_menu_sets`, `bill_menus`, `bill_menu_options`, `bill_menu_ingredients`

---

### 3.5 การคิดเงินและชำระเงิน (Checkout & Payment)

**ฟีเจอร์ที่ต้องทำ**

#### สรุปยอดบิล (แสดงชัดเจน)
```
ยอดรวมก่อนส่วนลด
- ส่วนลดระดับรายการ (item discount)
- ส่วนลดโปรโมชัน (promotion_discount_amount)
- ส่วนลดท้ายบิล (bill_discount_amount หรือ %)
= ยอดหลังส่วนลด
+ Service Charge (%)
= ยอดก่อน VAT
+ VAT (IN / EX / NO)
= ยอดรวมสุทธิ (Grand Total)
```

#### การชำระเงิน
- รับชำระหลายช่องทางในบิลเดียว (Split Payment)
- ช่องทางที่รองรับ: เงินสด, โอนเงิน, บัตรเครดิต, QR Code ฯลฯ (ตามที่ร้านตั้งค่า)
- คำนวณค่าธรรมเนียม payment ที่ลูกค้าจ่ายเพิ่ม หรือที่ร้านรับภาระ
- แสดงเงินทอน

#### สะสมพอยต์
- ดึงข้อมูลสมาชิก (center_customers) จากเบอร์โทร/รหัสสมาชิก
- แสดงพอยต์คงเหลือ
- คำนวณพอยต์ที่จะได้รับจากบิลนี้ (ตาม config: เช่น 100บาท = 10พอยต์)
- ใช้แลกพอยต์ (Redeem)

#### พิมพ์ใบเสร็จ
- พิมพ์ไปเครื่องพิมพ์ที่กำหนด
- รองรับเปิดลิ้นชักเงิน

**Tables ที่เกี่ยวข้อง:** `bills`, `bill_payments`, `payment_methods`, `bill_numbers`, `center_customers`, `center_point_histories`

---

### 3.6 การจัดการสต็อกวัตถุดิบ (Ingredient & Stock Management)

**ฟีเจอร์ที่ต้องทำ**

#### Master Data
- CRUD วัตถุดิบ (ภาษาไทย/อังกฤษ)
- กำหนดหน่วยนับ 3 แบบ: **หน่วยซื้อ (B)**, **หน่วยตัด/ใช้ (C)**, **หน่วยแสดงผล (D)**
- กำหนดสูตรวัตถุดิบต่อเมนู (Recipe)

#### รับสินค้าเข้า (Purchase / Buy)
- สร้างใบซื้อวัตถุดิบ (buys)
- ระบุ Lot No., วันผลิต (MFD), วันหมดอายุ (EXP)
- บันทึกการชำระเงินค่าซื้อ (cash/transfer/credit card/cheque)
- ระบบอัปเดตสต็อกอัตโนมัติ (Moving Average Cost)

#### ปรับปรุงสต็อก (Adjust)
- นับสต็อกจริงและปรับให้ตรง
- บันทึกส่วนต่าง (qty_diff, cost_diff)

#### นำสต็อกออก (Stock Removal / Void)
- บันทึกการทิ้ง / สูญเสีย / ใช้งานอื่น

#### ดูสต็อกคงเหลือ
- แสดงปริมาณและต้นทุนเฉลี่ยต่อสาขา

**Tables ที่เกี่ยวข้อง:** `ingredients`, `ingredient_units`, `menu_ingredients`, `stock_ingredients`, `stock_ingredient_items`, `buys`, `buy_items`, `buy_payment_notes`, `adjusts`, `adjust_items`, `stock_removals`, `stock_removal_items`

---

### 3.7 ระบบ CRM ลูกค้า & พอยต์ (Center Customer & Loyalty)

**ฟีเจอร์ที่ต้องทำ**
- ค้นหาสมาชิกจากเบอร์โทร / รหัสสมาชิก / ชื่อ
- สมัครสมาชิกใหม่ (ชื่อ, เบอร์โทร, อีเมล, เพศ, วันเกิด, LINE UID)
- แสดงประวัติการซื้อข้ามสาขา
- ดูพอยต์คงเหลือ และประวัติพอยต์ (สะสม / ใช้ / หมดอายุ / ยกเลิก)
- พอยต์หมดอายุสิ้นปีถัดไป (ตาม `expired_at`)

**Tables ที่เกี่ยวข้อง:** `center_customers`, `center_customer_bill_histories`, `center_point_histories`

---

### 3.8 ตั้งค่าระบบ (Settings)

**ฟีเจอร์ที่ต้องทำ**

| หัวข้อ | รายละเอียด |
|---|---|
| ข้อมูลบริษัท/สาขา | ชื่อ, ที่อยู่, เลขภาษี, เบอร์โทร |
| การตั้งค่า VAT | IN (รวม) / EX (แยก) / NO (ไม่มี) ต่อสาขา |
| ช่องทางชำระเงิน | เพิ่ม/แก้ไข payment methods + ค่าธรรมเนียม |
| ช่องทางการสั่ง | Grab, LineMan, ShopeeFood + % fee |
| รูปแบบเลขบิล | prefix + format (yyyymm, yymm ฯลฯ) |
| อุปกรณ์ | เชื่อมต่อเครื่องพิมพ์, ลิ้นชักเงิน |
| พอยต์สะสม | กำหนดอัตราพอยต์ (100บาท = X พอยต์) |
| จัดการผู้ใช้ | เพิ่ม/แก้ไข/ปิดใช้งานผู้ใช้ในบริษัท |

**Tables ที่เกี่ยวข้อง:** `configs`, `payment_methods`, `order_channels`, `bill_numbers`, `output_devices`, `users`, `branchs`, `companys`

---

## 4. สรุปหน้าจอ (Screen List)

### กลุ่ม POS (หน้าขาย — ใช้งานประจำวัน)

| หน้า | คำอธิบาย |
|---|---|
| `/login` | เข้าสู่ระบบ |
| `/select-branch` | เลือกสาขา |
| `/shift/open` | เปิดกะ — ระบุยอดเงินเริ่มต้นในลิ้นชัก |
| `/shift/close` | ปิดกะ — สรุปและตรวจนับเงินสด (Cash Reconcile) |
| `/tables` | ผังโต๊ะ (Floor Map) พร้อม Buffet Timer |
| `/kitchen` | Kitchen Display System (KDS) — หน้าจอครัว |
| `/pos/:billId` | หน้าหลัก POS — รับออเดอร์ |
| `/pos/:billId/checkout` | คิดเงินและชำระเงิน |
| `/pos/:billId/receipt` | พรีวิวและพิมพ์ใบเสร็จ |

### กลุ่ม Back Office (ตั้งค่าและบริหาร)

| หน้า | คำอธิบาย |
|---|---|
| `/menu/packages` | จัดการแพ็กเกจ/บุฟเฟต์ |
| `/menu/sets` | จัดการชุดเมนู |
| `/menu/items` | จัดการรายการอาหาร |
| `/menu/options` | จัดการตัวเลือกอาหาร |
| `/menu/categories` | จัดการหมวดหมู่การแสดงผล |
| `/stock/ingredients` | Master วัตถุดิบ |
| `/stock/buy` | ใบรับสินค้า (Purchase) |
| `/stock/adjust` | ปรับปรุงสต็อก |
| `/stock/removal` | นำสต็อกออก |
| `/stock/report` | รายงานสต็อกคงเหลือ |
| `/customers` | จัดการสมาชิก CRM |
| `/customers/:id` | ประวัติสมาชิกและพอยต์ |
| `/settings/company` | ตั้งค่าบริษัท/สาขา |
| `/settings/devices` | ตั้งค่าอุปกรณ์ |
| `/settings/payment` | ตั้งค่าช่องทางชำระเงิน |
| `/settings/channels` | ตั้งค่า Order Channels |
| `/settings/users` | จัดการผู้ใช้งาน |
| `/settings/points` | ตั้งค่าพอยต์สะสม |

---

## 5. กฎการคำนวณที่สำคัญ

### 5.1 การคำนวณยอดบิล

```
subtotal_after_item_discount
  - promotion_discount_amount
  - bill_discount_amount (หรือ bill_discount_percent × subtotal)
= subtotal_after_bill_discount
  + service_charge_percent × subtotal_after_bill_discount
= amount_before_vat
  + vat_percent_amount  (ถ้า vat_type = EX)
= grand_total
```

> กรณี `vat_type = IN`: VAT ถูกรวมในราคาสินค้าแล้ว → ต้องคำนวณ back-out  
> กรณี `vat_type = NO`: ไม่มี VAT เลย

### 5.2 ค่าธรรมเนียม Payment

```
customer_fee = base_amount × customer_fee_percent + customer_fee_fixed
merchant_fee = base_amount × merchant_fee_percent + merchant_fee_fixed
```

### 5.3 สะสมพอยต์

- ค่าใน `configs` รูปแบบ: `"100,10"` = ทุก 100 บาท ได้ 10 พอยต์
- พอยต์จากเมนู (menu_point) + พอยต์จากบิล (bill_point) = total_point

---

## 6. ข้อกำหนดทางเทคนิค (Technical Requirements)

### การพิมพ์ (Printing with Failover)

- รองรับเชื่อมต่อเครื่องพิมพ์ผ่าน: **Network, USB, LAN, Bluetooth**
- พิมพ์ได้หลายเครื่องพร้อมกัน (แยกตามหมวดหมู่/ครัว)
- รองรับการเปิดลิ้นชักเงิน (`output_calls`)
- จัดการ print status: `pending` → `printed` / `failed`
- **Failover / Re-route:** เมื่อสถานะเป็น `failed` ระบบต้องแสดง Dialog ถามพนักงานว่าจะ Re-route ไปพิมพ์ที่เครื่องอื่นชั่วคราวหรือไม่ โดยแสดงรายชื่ออุปกรณ์ออนไลน์ที่มีอยู่ให้เลือก

### QR Code สั่งอาหาร

- แต่ละโต๊ะมี `table_order_token` สำหรับสร้าง QR ให้ลูกค้าสแกนสั่งเอง
- แต่ละบิลมี `bill_order_token` สำหรับ Dine-In

### Multi-Language

- เมนูทั้งหมดรองรับ 2 ภาษา: **ภาษาไทย (th)** และ **ภาษาอังกฤษ (en)**
- ชื่อโต๊ะ, โซน, หมวดหมู่ รองรับ 2 ภาษา

### Shift Management (การจัดการกะพนักงาน)

- **Open Shift:** พนักงานระบุยอดเงินเริ่มต้นในลิ้นชัก (Opening Cash) ก่อนเริ่มขาย บันทึก timestamp และผู้เปิดกะ
- **Close Shift / Cash Reconcile:** สรุปยอดเงินสดตามทฤษฎี (ยอดเปิด + ยอดรับสด - ยอดทอน) เทียบกับเงินนับจริง แสดงส่วนต่าง (Over/Short) เพื่อตรวจสอบเงินหาย

```
เงินสดในลิ้นชัก (ทฤษฎี) =
  เงินเปิดกะ
  + ยอดเงินสดรับจากบิลทั้งหมดในกะ
  - ยอดเงินทอนทั้งหมด
```

> ข้อมูลที่ต้องใช้: `bills.change`, `bill_payments` (เฉพาะ payment_method ประเภทเงินสด), `users.id` (ผู้เปิด/ปิดกะ)

### Kitchen Display System (KDS)

- หน้าจอสำหรับแสดงในครัว แสดงรายการอาหารที่ยังอยู่ในสถานะ `ordered`
- พ่อครัวกด **"Mark as Served"** → อัปเดต `order_status = served` แบบ Real-time
- หน้า POS และผังโต๊ะต้องรับการเปลี่ยนแปลงสถานะโดยอัตโนมัติ (WebSocket หรือ Polling)
- แสดงเวลาที่รอ (waiting time) ของแต่ละ order เพื่อ prioritize รายการที่รอนาน

### Offline Mode

- หากอินเทอร์เน็ตหลุด ระบบต้องสามารถเปิดบิล รับออเดอร์ และชำระเงินได้ต่อเนื่อง
- เก็บข้อมูลออเดอร์ไว้ใน **Local Storage / SQLite** ก่อน
- เมื่อเน็ตกลับมา ให้ Sync ข้อมูลขึ้น Server อัตโนมัติ (Queue-based sync)
- แสดง indicator ชัดเจนเมื่ออยู่ใน Offline Mode เพื่อให้พนักงานรับรู้

### Buffet Timer (นาฬิกานับถอยหลัง)

- หน้าผังโต๊ะต้องแสดง **Visual Timer** บนโต๊ะที่เปิดบิลแบบบุฟเฟต์ คำนวณจาก:
  ```
  เวลาที่เหลือ = bill_start_at + dining_time_minutes - เวลาปัจจุบัน
  ```
- เปลี่ยนสีตามความเร่งด่วน: 🟢 มีเวลาเหลือมาก → 🟡 เหลือ < 15 นาที → 🔴 หมดเวลาแล้ว
- ไม่ต้องกดเข้าไปดูในบิล พนักงานเห็นสถานะได้จากผังโต๊ะเลย

### Subscription / Limits

- แต่ละบริษัทมีวันหมดอายุ (`expired_at`)
- จำกัดจำนวนสาขา (`total_branch_limit`) และจำนวนผู้ใช้ (`total_user_limit`)
- ระบบต้องตรวจสอบก่อนอนุญาตสร้างสาขา/ผู้ใช้ใหม่

---

## 7. สรุปภาพรวม

```
┌─────────────────────────────────────────────────┐
│                  KAMRAI POS                     │
│          ระบบ POS สำหรับร้านอาหาร               │
├──────────────┬──────────────┬───────────────────┤
│  หน้าขาย POS │  Back Office │  Center / CRM     │
│              │              │                   │
│ • ผังโต๊ะ    │ • จัดการเมนู │ • สมาชิกกลาง      │
│ • รับออเดอร์ │ • สต็อก/วัตถุดิบ│• พอยต์ข้ามสาขา │
│ • คิดเงิน    │ • ซื้อสินค้า │ • ประวัติการซื้อ  │
│ • พิมพ์ใบเสร็จ│• ตั้งค่าระบบ│                   │
│ • สะสมพอยต์  │ • จัดการผู้ใช้│                  │
└──────────────┴──────────────┴───────────────────┘
         ↕ รองรับ: Dine-In | Take Away | Delivery
         ↕ ประเภทเมนู: A-La-Carte | SET | Buffet
         ↕ ช่องทางสั่ง: WalkIn | Grab | LineMan | ShopeeFood
```

---

*จัดทำโดย: Claude Code | อ้างอิงจาก kamrai POS.sql*
