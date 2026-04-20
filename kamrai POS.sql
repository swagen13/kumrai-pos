CREATE TABLE `users` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `company_owner` tinyint COMMENT '1=owner',
  `username` varchar(100),
  `password` varchar(255),
  `first_name` varchar(150),
  `last_name` varchar(150),
  `full_name` varchar(255),
  `email` varchar(150),
  `phone` varchar(20),
  `status` tinyint COMMENT '0=inactive,1=active',
  `last_login_at` timestamp,
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `user_tokens` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `user_id` integer,
  `token` varchar(255),
  `end_session_at` datetime,
  `kill_session_by` bigint
);

CREATE TABLE `companys` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `expired_at` timestamp,
  `total_branch_limit` integer DEFAULT 10,
  `total_user_limit` integer DEFAULT 100,
  `company_code` varchar(50),
  `company_name` varchar(255),
  `company_sub_name` varchar(150),
  `company_type` varchar(100),
  `company_tax_no` varchar(20),
  `company_phone` varchar(20),
  `company_email` varchar(150),
  `company_address` text,
  `company_province` integer,
  `company_district` integer,
  `company_sub_district` integer,
  `company_zipcode` varchar(5),
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `branchs` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_code` varchar(50),
  `branch_name` varchar(255),
  `branch_sub_name` varchar(150),
  `branch_type` varchar(100),
  `branch_tax_no` varchar(20),
  `branch_phone` varchar(20),
  `branch_email` varchar(150),
  `branch_address` text,
  `branch_province` integer,
  `branch_district` integer,
  `branch_sub_district` integer,
  `branch_zipcode` varchar(5),
  `branch_sell_vat_type` char(2) DEFAULT 'IN' COMMENT 'IN=INCLUDE, EX=EXCLUDE, NO=NONE',
  `branch_vat_percent` decimal(5,2),
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `configs` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `config_type` varchar(20) COMMENT 'เช่น Point',
  `config_value` varchar(20) COMMENT 'เช่น 100บาทได้ 10พ้อย เก็บ 100,10'
);

CREATE TABLE `output_devices` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `output_name` varchar(150),
  `output_type` varchar(150) COMMENT 'Printer, CashDrawer, PrinterWithCashDrawer',
  `output_connect_type` varchar(150) COMMENT 'Network, USB, Bluetooth',
  `output_calls` tinyint COMMENT 'สั่งให้เครื่องพิมพ์ร้องกรณีอุปกรณ์เป็นเครื่องพิมพ์ 0=No,1=Yes',
  `ip_address` varchar(150),
  `port_number` integer,
  `paper_width` integer,
  `charactor_code` varchar(20),
  `command_set` varchar(20),
  `device_address` varchar(255) COMMENT 'USB path or Bluetooth address',
  `auto_cutter` tinyint DEFAULT 1 COMMENT '0=No,1=Yes',
  `display_category_ids` json COMMENT 'หมวดหมู่ที่เครื่องพิมพ์นี้รับงาน เช่น [1,2,3]',
  `is_active` tinyint DEFAULT 1 COMMENT '0=inactive,1=active',
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `promotions` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `promo_code` varchar(50),
  `promo_name` varchar(150),
  `promo_desc` text,
  `promo_type` char(2) COMMENT '01=menu_discount, 02=bill_discount, 03=buy_x_get_y, 04=member_only',
  `discount_type` char(1) COMMENT 'P=percent, A=amount, F=free, S=special_price',
  `discount_value` decimal(10,2),
  `min_bill_amount` decimal(10,2),
  `min_qty` integer,
  `is_member_only` tinyint COMMENT '0=no, 1=yes',
  `menu_ids` json COMMENT 'เมนูที่ร่วมโปร เช่น [101,102]',
  `buy_menu_ids` json COMMENT 'ใช้กับซื้อ X แถม Y',
  `get_menu_ids` json COMMENT 'เมนูที่แถม หรือ เมนูที่ได้สิทธิ์',
  `category_ids` json COMMENT 'ถ้าจะอิงหมวด เช่น [1,2,3]',
  `buy_qty` integer,
  `get_qty` integer,
  `start_date` datetime,
  `end_date` datetime,
  `usage_limit` integer COMMENT 'จำนวนใช้รวมทั้งหมด',
  `allow_with_other_promotion` tinyint COMMENT '0=no,1=yes',
  `usage_limit_per_member` integer,
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `promotion_branchs` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `promotion_id` integer,
  `company_id` integer,
  `branch_id` integer
);

CREATE TABLE `display_categorys` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `category_name_th` varchar(150) COMMENT 'ต้ม, ทอด, ย่าง, ยำ, ผัก, ทางเล่น',
  `category_name_en` varchar(150) COMMENT 'Boiled, fried, grilled, salad, vegetables, snacks',
  `category_output_printer_id` integer COMMENT 'สำหรับต้องการให้ส่งรายการอาหารไปพิมพ์'
);

CREATE TABLE `menu_buffets` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `menu_type` varchar(1) COMMENT 'A=A-La-Carte, S=SET, B=Buffet',
  `menu_buffet_name_th` varchar(255),
  `menu_buffet_name_en` varchar(255),
  `allow_all_branches` tinyint COMMENT '0=No,1=Yes',
  `price` decimal(10,2),
  `point` integer DEFAULT 0,
  `stamp` integer DEFAULT 0,
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `menu_buffet_packages` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `menu_buffet_id` integer,
  `menu_set_id` integer,
  `special_price` decimal(10,2)
);

CREATE TABLE `menu_buffet_branchs` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `menu_buffet_id` integer
);

CREATE TABLE `menu_sets` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `menu_buffet_id` integer,
  `display_category_id` integer,
  `category_output_printer_id` integer COMMENT 'สำหรับต้องการให้ส่งรายการอาหารไปพิมพ์ กรณีกำหนดแยกเป็นเมนูให้ยึดตามเมนูในการสั่งพิมพ์',
  `menu_set_name_th` varchar(255),
  `menu_set_name_en` varchar(255),
  `show_in_menu` tinyint DEFAULT 1 COMMENT '0=No,1=Yes ใช้สำหรับสร้างมาเพื่อนำไปสร้างเมนูเพื่อนำไปเป็น Set, buffet',
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `menus` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `menu_set_id` integer,
  `menu_name_th` varchar(255),
  `menu_name_en` varchar(255),
  `has_option` tinyint COMMENT '0=none,1=has',
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `menu_options` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `menu_buffet_id` integer,
  `menu_set_id` integer,
  `menu_id` integer,
  `is_request` tinyint COMMENT '0=No,1=Yes',
  `sort` int COMMENT 'ลำดับการเรียง',
  `option_type` char(1) COMMENT 'Addon,Multi,Text',
  `min_value` int COMMENT 'กรณีคำถามมีตัวเลือก Multi และ is_request=Yes บังคับขั้นต่ำคือ1',
  `max_value` int DEFAULT 1 COMMENT 'กรณีคำถามมีตัวเลือก Multi',
  `option_name_th` varchar(255),
  `option_name_en` varchar(255),
  `option_value_th` varchar(255) COMMENT 'เก็บตัวเลือกแบบ Comma array',
  `option_value_en` varchar(255) COMMENT 'เก็บตัวเลือกแบบ Comma array',
  `option_price` varchar(255) COMMENT 'เก็บราคาแบบ Comma array'
);

CREATE TABLE `ingredients` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `ingredient_name_th` varchar(255),
  `ingredient_name_en` varchar(255),
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `ingredient_units` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `ingredient_id` integer,
  `ingredient_unit_th` varchar(255),
  `ingredient_unit_en` varchar(255),
  `value_per_use_unit` decimal(10,3),
  `unit_type` char(1) COMMENT 'C=For cutting stock, B=The primary purchasing unit, D=Display stock'
);

CREATE TABLE `menu_ingredients` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `menu_id` integer,
  `ingredient_id` integer,
  `value_per_use_unit` decimal(10,3)
);

CREATE TABLE `stock_ingredients` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `ingredient_id` integer,
  `stock_qty` decimal(10,2),
  `avg_cost` decimal(14,6),
  `last_avg_cost` decimal(14,6)
);

CREATE TABLE `stock_ingredient_items` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `ingredient_id` integer,
  `stock_ingredient_id` integer,
  `created_type` char(1) COMMENT 'A=Adjust, B=Buy, T=From Transfer',
  `adjust_id` integer,
  `buy_id` integer,
  `transfer_id` integer COMMENT 'ไว้อนาคตทำ โอน-รับ',
  `item_qty` decimal(10,2),
  `item_avg_cost` decimal(14,6),
  `item_process_qty` decimal(14,6),
  `item_process_per_unit` decimal(10,3),
  `item_process_unit_th` varchar(255),
  `item_process_unit_en` varchar(255),
  `item_lot_no` varchar(50),
  `item_exp` date,
  `item_mfd` date,
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `dining_zone` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `zone_name_th` varchar(100),
  `zone_name_en` varchar(100),
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `dining_tables` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `dining_zone_id` integer,
  `code` varchar(20) UNIQUE NOT NULL,
  `table_name_th` varchar(100),
  `table_name_en` varchar(100),
  `capacity` int NOT NULL DEFAULT 4,
  `table_order_token` varchar(150) COMMENT 'สำหรับการสร้าง QR สั่งอาหารประจำโต๊ะ',
  `table_status` varchar(20) NOT NULL DEFAULT 'available' COMMENT 'available=ว่าง / occupied=ไม่ว่าง / cleaning=ทำความสะอาด',
  `note` text,
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `bill_numbers` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `bill_type` varchar(20) COMMENT 'Sell=ขาย, Buy=ซื้อ, Adjust=ปรับปรุง, Void=นำออก, Transfer=โอน, ReceiveTransfer=รับโอน',
  `running_format` varchar(6) COMMENT 'yyyymm, yymm, mmyyyy, mmyy, yy',
  `current_number` integer COMMENT 'ระบบเช็คว่าถ้าเลขไม่ครบ 5 หลักให้เติม 0 ข้างหน้าจนครบ',
  `bill_prefix` varchar(5)
);

CREATE TABLE `payment_methods` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `method_name` varchar(100) COMMENT 'ชื่อที่ร้านตั้งเอง เช่น เงินสด, โอน SCB, บัตรเครดิต KBank',
  `customer_fee_fixed` decimal(10,2) DEFAULT 0,
  `customer_fee_percent` decimal(8,4) DEFAULT 0,
  `merchant_fee_fixed` decimal(10,2) DEFAULT 0,
  `merchant_fee_percent` decimal(8,4) DEFAULT 0,
  `fee_vat_percent` decimal(8,4) DEFAULT 0 COMMENT 'ถ้ามี VAT บนค่าธรรมเนียม',
  `payment_method_note` varchar(150),
  `is_custom` tinyint DEFAULT 0 COMMENT '1 = ร้านสร้างเอง',
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `bill_payments` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `bill_id` integer,
  `payment_method_id` integer,
  `payment_method_name` varchar(100),
  `base_amount` decimal(12,2) DEFAULT 0 COMMENT 'ยอดฐานที่ใช้คิด fee',
  `customer_fee_amount` decimal(12,2) DEFAULT 0 COMMENT 'ค่าธรรมเนียมที่บวกเพิ่มลูกค้า',
  `paid_amount` decimal(12,2) DEFAULT 0 COMMENT 'ยอดที่ลูกค้าจ่ายใน payment นี้',
  `net_received_amount` decimal(12,2) DEFAULT 0 COMMENT 'ยอดสุทธิที่ร้านได้รับจาก payment นี้',
  `merchant_fee_amount` decimal(12,2) DEFAULT 0 COMMENT 'ค่าธรรมเนียมที่ร้านรับภาระ',
  `bill_payment_note` varchar(150),
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `order_channels` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `order_channel_name` varchar(150) COMMENT 'WalkIn, Grab, LineMan, ShopeeFood',
  `order_channel_fee_amount` decimal(10,2) DEFAULT 0,
  `order_channel_fee_percent` decimal(8,4) DEFAULT 0,
  `is_custom` tinyint DEFAULT 0 COMMENT '1 = ร้านสร้างเอง',
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `bills` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `dining_table_id` integer,
  `order_channels_id` integer,
  `bill_number` varchar(20),
  `bill_type` varchar(20) COMMENT 'dine_in=ทานที่ร้าน, take_away=กลับบ้าน, delivery=จัดส่ง',
  `dine_in_type` char(1) COMMENT 'A=A-La-Carte, B=Buffet',
  `bill_order_token` varchar(150) COMMENT 'สำหรับการสร้าง QR สั่งอาหารประจำบิล เฉพาะ dine_in เท่านั้น',
  `bill_status` varchar(20) NOT NULL DEFAULT 'open' COMMENT 'open=เปิดการขาย, completed=จบการขาย, cancelled=ยกเลิก',
  `bill_start_at` timestamp,
  `bill_end_at` timestamp COMMENT 'Buffet is not null',
  `bill_checkout_at` timestamp COMMENT 'At checkout Time',
  `dining_time_minutes` integer COMMENT 'Dining time เวลาใช้ทานต่อโต๊ะ',
  `subtotal_after_item_discount` decimal(10,2),
  `promotion_discount_amount` decimal(10,2),
  `bill_discount_amount` decimal(10,2),
  `bill_discount_percent` decimal(5,2),
  `bill_discount_percent_amount` decimal(10,2),
  `subtotal_after_bill_discount` decimal(10,2),
  `service_charge_percent` decimal(5,2),
  `service_charge_percent_amount` decimal(10,2),
  `amount_before_vat` decimal(10,2),
  `vat_type` char(2) DEFAULT 'IN' COMMENT 'IN=INCLUDE, EX=EXCLUDE, NO=NONE',
  `vat_percent` decimal(5,2),
  `vat_percent_amount` decimal(10,2),
  `grand_total` decimal(10,2),
  `paid_status` varchar(20) DEFAULT 'UNPAID' COMMENT 'UNPAID=ยังไม่ชำระ, PAID=ชำระแล้ว, PARTIAL_PAID=ชำระบางส่วน',
  `paid_amount` decimal(10,2),
  `paid_payment_fee_amount` decimal(10,2),
  `grand_paid` decimal(10,2),
  `change` decimal(10,2),
  `order_channel_fee_percent` decimal(8,4) DEFAULT 0 COMMENT 'เป็นค่าว่างถ้าฟิกยอดจ่าย',
  `order_channel_fee_amount` decimal(10,2) DEFAULT 0,
  `bill_note` varchar(255),
  `menu_point` decimal(10,2),
  `bill_point` decimal(10,2),
  `total_point` decimal(10,2),
  `menu_stamp` integer,
  `menu_stamp_recived` integer,
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `bill_menu_buffets` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `bill_id` integer,
  `item_type` varchar(1) COMMENT 'F=Foods, P=Promotions',
  `menu_type` varchar(1) COMMENT 'A=A-La-Carte, S=SET, B=Buffet',
  `menu_buffet_id` integer,
  `menu_buffet_name_th` varchar(255),
  `menu_buffet_name_en` varchar(255),
  `price` decimal(10,2),
  `stamp` integer DEFAULT 0,
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `bill_menu_sets` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `bill_id` integer,
  `menu_buffet_id` integer,
  `display_category_id` integer,
  `menu_set_name_th` varchar(255),
  `menu_set_name_en` varchar(255),
  `print_status` varchar(10) COMMENT 'pending=รอส่ง, printed=ปริ้นสำเร็จ, failed=ปริ้นไม่สำเร็จ',
  `order_status` varchar(15) COMMENT 'ordered=รับออเดอร์แล้ว, served=เสิร์ฟแล้ว, cancelled=ยกเลิก',
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `bill_menus` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `bill_id` integer,
  `menu_buffet_id` integer,
  `bill_menu_set_id` integer,
  `menu_name_th` varchar(255),
  `menu_name_en` varchar(255),
  `qty` integer NOT NULL DEFAULT 1,
  `item_price` decimal(10,2) NOT NULL DEFAULT 0,
  `item_discount` decimal(10,2) NOT NULL DEFAULT 0,
  `has_option` tinyint COMMENT '0=none,1=has'
);

CREATE TABLE `bill_menu_options` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `bill_id` integer,
  `menu_buffet_id` integer,
  `bill_menu_set_id` integer,
  `bill_menu_id` integer,
  `is_request` tinyint COMMENT '0=No,1=Yes',
  `option_name_th` varchar(255),
  `option_name_en` varchar(255),
  `choose_th` varchar(255),
  `choose_en` varchar(255)
);

CREATE TABLE `bill_menu_ingredients` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `bill_id` integer,
  `menu_buffet_id` integer,
  `bill_menu_set_id` integer,
  `bill_menu_id` integer,
  `ingredient_id` integer,
  `value_use` decimal(10,3)
);

CREATE TABLE `buys` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `bill_number` varchar(20),
  `buy_date` date,
  `subtotal` decimal(10,2),
  `bill_discount_amount` decimal(10,2),
  `bill_discount_percent` decimal(5,2),
  `bill_discount_percent_amount` decimal(10,2),
  `subtotal_after_bill_discount` decimal(10,2),
  `service_charge_percent` decimal(5,2),
  `service_charge_percent_amount` decimal(10,2),
  `amount_before_vat` decimal(10,2),
  `vat_type` char(2) DEFAULT 'IN' COMMENT 'IN=INCLUDE, EX=EXCLUDE, NO=NONE',
  `vat_percent` decimal(5,2),
  `vat_percent_amount` decimal(10,2),
  `grand_total` decimal(10,2),
  `paid_status` varchar(20) DEFAULT 'UNPAID' COMMENT 'UNPAID=ยังไม่ชำระ, PAID=ชำระแล้ว, PARTIAL_PAID=ชำระบางส่วน',
  `paid_amount` decimal(10,2),
  `paid_payment_fee_amount` decimal(10,2),
  `grand_paid` decimal(10,2),
  `buy_note` varchar(255),
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `buy_items` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `buy_id` integer,
  `ingredient_id` integer,
  `item_qty` decimal(10,2),
  `item_avg_cost` decimal(14,6),
  `item_process_qty` decimal(14,6),
  `item_process_avg_cost` decimal(14,6),
  `item_process_per_unit` decimal(10,3),
  `item_process_unit_th` varchar(255),
  `item_process_unit_en` varchar(255),
  `item_lot_no` varchar(50),
  `item_exp` date,
  `item_mfd` date,
  `item_note` varchar(150),
  `has_adjust` tinyint COMMENT '0=No,1=Yes'
);

CREATE TABLE `buy_payment_notes` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `buy_id` integer,
  `payment_type` char(5) COMMENT 'null, Cash, Transfer, CreditCard, Check, Other',
  `payment_amt` decimal(12,2),
  `payment_fee` decimal(12,2),
  `payment_date` date,
  `payment_note` varchar(150),
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `adjusts` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `bill_number` varchar(20),
  `adjust_date` date,
  `total_cost_diff` decimal(14,6),
  `adjust_note` varchar(255),
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `adjust_items` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `adjust_id` integer,
  `ingredient_id` integer,
  `qty_before` decimal(10,2),
  `avg_cost_before` decimal(14,6),
  `lot_no_before` varchar(50),
  `exp_before` date,
  `mfd_before` date,
  `qty_after` decimal(10,2),
  `avg_cost_after` decimal(14,6),
  `lot_no_after` varchar(50),
  `exp_after` date,
  `mfd_after` date,
  `qty_diff` decimal(10,2),
  `avg_cost_diff` decimal(14,6),
  `total_cost_diff` decimal(14,6)
);

CREATE TABLE `stock_removals` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `bill_number` varchar(20),
  `stock_removal_date` date,
  `total_cost` decimal(14,6),
  `stock_removal_note` varchar(255),
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `stock_removal_items` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `stock_removal_id` integer,
  `ingredient_id` integer,
  `qty` decimal(10,2),
  `avg_cost` decimal(14,6),
  `total_cost` decimal(14,6)
);

CREATE TABLE `center_permission_groups` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `group_name` varchar(100) COMMENT 'เช่น เจ้าของกิจการ, ผู้จัดการ, แคชเชียร์',
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `center_permission_menus` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `menu_name` varchar(100),
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `center_user_permissions` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `company_id` integer,
  `branch_id` integer,
  `user_id` integer,
  `permission_group_id` integer,
  `permission_menu_id` integer
);

CREATE TABLE `center_user_branch_permissions` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `user_id` integer,
  `company_id` integer,
  `branch_id` integer
);

CREATE TABLE `center_user_tokens` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `user_id` integer,
  `token` varchar(255),
  `end_session_at` datetime,
  `kill_session_by` bigint
);

CREATE TABLE `center_users` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `center_company_id` integer,
  `company_owner` tinyint COMMENT '1=owner',
  `username` varchar(100),
  `password` varchar(255),
  `first_name` varchar(150),
  `last_name` varchar(150),
  `full_name` varchar(255),
  `email` varchar(150),
  `phone` varchar(20),
  `status` tinyint COMMENT '0=inactive,1=active',
  `last_login_at` timestamp,
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `center_restaurant_types` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `type_name` varchar(150),
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `center_companys` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `db_no` integer NOT NULL,
  `expired_at` timestamp,
  `total_branch_limit` integer DEFAULT 10,
  `total_branch` integer DEFAULT 0,
  `total_branch_inactive` integer DEFAULT 0,
  `total_user_limit` integer DEFAULT 100,
  `last_active_at` timestamp,
  `company_code` varchar(50),
  `company_name` varchar(255),
  `company_sub_name` varchar(150),
  `company_type` varchar(100),
  `company_tax_no` varchar(20),
  `company_phone` varchar(20),
  `company_email` varchar(150),
  `company_address` text,
  `company_province` integer,
  `company_district` integer,
  `company_sub_district` integer,
  `company_zipcode` varchar(5),
  `review_score` decimal(2,1) DEFAULT 5 COMMENT 'เต็ม 5.0',
  `web_is_publish` tinyint DEFAULT 0 COMMENT '0=inactive,1=active',
  `web_theme` tinyint NOT NULL COMMENT 'เลือกธีมเว็บของตนเอง',
  `web_can_review` tinyint DEFAULT 1 COMMENT '0=ปิดรีวิว,1=เปิดรีวิว',
  `introduction_text` varchar(255),
  `logo_image` varchar(255),
  `cover_image` varchar(255),
  `others_image` text,
  `detail_image` text,
  `seo_key_image` text,
  `slug` varchar(150),
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `center_company_types` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `center_company_id` integer,
  `center_restaurant_type_id` integer
);

CREATE TABLE `center_company_review_comments` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `center_company_id` integer,
  `center_branch_id` integer,
  `center_customer_id` integer,
  `review_score` decimal(2,1) DEFAULT 5 COMMENT 'เต็ม 5.0',
  `comment_review` text
);

CREATE TABLE `center_branchs` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `center_company_id` integer,
  `branch_code` varchar(50),
  `branch_name` varchar(255),
  `branch_sub_name` varchar(150),
  `branch_type` varchar(100),
  `branch_tax_no` varchar(20),
  `branch_phone` varchar(20),
  `branch_email` varchar(150),
  `branch_address` text,
  `branch_province` integer,
  `branch_district` integer,
  `branch_sub_district` integer,
  `branch_zipcode` varchar(5),
  `branch_sell_vat_type` char(2) DEFAULT 'IN' COMMENT 'IN=INCLUDE, EX=EXCLUDE, NO=NONE',
  `branch_vat_percent` decimal(5,2),
  `allow_booking_queue` tinyint DEFAULT 0 COMMENT '0=ปิดจองคิว,1=เปิดจองคิว',
  `allow_booking_start_time` tinyint DEFAULT 1,
  `allow_booking_end_time` tinyint DEFAULT 1,
  `current_booking_queue_no` int DEFAULT 0,
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_at` timestamp,
  `created_by` integer,
  `updated_at` timestamp,
  `updated_by` integer
);

CREATE TABLE `center_customers` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `member_code` varchar(30) UNIQUE NOT NULL COMMENT 'รหัสสมาชิกกลาง',
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100),
  `full_name` varchar(255) COMMENT 'ชื่อเต็มสำหรับค้นหา first_name ต่อ last_name auto',
  `phone` varchar(20) UNIQUE NOT NULL,
  `email` varchar(150) UNIQUE,
  `line_uid` varchar(100),
  `gender` varchar(20),
  `birth_date` date,
  `point_balance` int NOT NULL DEFAULT 0 COMMENT 'แต้มคงเหลือปัจจุบัน',
  `total_spent` decimal(14,2) NOT NULL DEFAULT 0,
  `total_bill_count` int NOT NULL DEFAULT 0,
  `is_verified` boolean NOT NULL DEFAULT false,
  `last_bill_at` datetime,
  `admin_note` text,
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_by` bigint,
  `updated_by` bigint,
  `created_at` datetime,
  `updated_at` datetime
);

CREATE TABLE `center_customer_bookings` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `center_company_id` bigint,
  `center_branch_id` bigint,
  `center_customer_id` bigint,
  `guest_count` int,
  `queue_no` varchar(20)
);

CREATE TABLE `center_customer_bill_histories` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `center_customer_id` bigint NOT NULL,
  `center_company_id` bigint,
  `center_branch_id` bigint,
  `bill_no` varchar(50) NOT NULL,
  `bill_date` datetime NOT NULL,
  `grand_total` decimal(10,2),
  `points` int NOT NULL DEFAULT 0,
  `status` tinyint COMMENT '0=inactive,1=active',
  `created_by` bigint,
  `updated_by` bigint,
  `created_at` datetime,
  `updated_at` datetime
);

CREATE TABLE `center_point_histories` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `center_customer_id` bigint NOT NULL,
  `center_customer_bill_history_id` bigint,
  `center_company_id` bigint,
  `center_branch_id` bigint,
  `point_type` char(1) COMMENT 'Collect, Use, Expire, Adjust สำหรับยกเลิกพ้อยคืนจากร้านค้าและต้องยกเลิกภายใน 24ชม.',
  `point_value` int NOT NULL COMMENT 'ค่าบวก/ลบ เช่น 10, -5',
  `bill_no` varchar(50) COMMENT 'เป็นค่าว่างได้ กรณีเป็นการ void Point',
  `bill_date` datetime NOT NULL,
  `description` varchar(255),
  `expired_at` datetime COMMENT 'เป็นค่าว่างได้ กรณีเป็นการ void Point กำหนดให้หมดอายุในสิ้นปีถัดไป',
  `status` tinyint COMMENT '0=inactive,1=active'
);

CREATE TABLE `center_news` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `new_description` text,
  `new_img_name` varchar(50),
  `new_view_count` integer,
  `publish_date` datetime,
  `publish_to_date` datetime
);

-- ─────────────────────────────────────────────────────────────────────────────
-- Foreign Keys
-- ─────────────────────────────────────────────────────────────────────────────

ALTER TABLE `users` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);

ALTER TABLE `user_tokens` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `branchs` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);

ALTER TABLE `configs` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `configs` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);

ALTER TABLE `output_devices` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `output_devices` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);

ALTER TABLE `promotions` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);

ALTER TABLE `promotion_branchs` ADD FOREIGN KEY (`promotion_id`) REFERENCES `promotions` (`id`);
ALTER TABLE `promotion_branchs` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `promotion_branchs` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);

ALTER TABLE `display_categorys` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `display_categorys` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);
ALTER TABLE `display_categorys` ADD FOREIGN KEY (`category_output_printer_id`) REFERENCES `output_devices` (`id`);

ALTER TABLE `menu_buffets` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);

ALTER TABLE `menu_buffet_packages` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `menu_buffet_packages` ADD FOREIGN KEY (`menu_buffet_id`) REFERENCES `menu_buffets` (`id`);
ALTER TABLE `menu_buffet_packages` ADD FOREIGN KEY (`menu_set_id`) REFERENCES `menu_sets` (`id`);

ALTER TABLE `menu_buffet_branchs` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `menu_buffet_branchs` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);
ALTER TABLE `menu_buffet_branchs` ADD FOREIGN KEY (`menu_buffet_id`) REFERENCES `menu_buffets` (`id`);

ALTER TABLE `menu_sets` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `menu_sets` ADD FOREIGN KEY (`menu_buffet_id`) REFERENCES `menu_buffets` (`id`);
ALTER TABLE `menu_sets` ADD FOREIGN KEY (`display_category_id`) REFERENCES `display_categorys` (`id`);
ALTER TABLE `menu_sets` ADD FOREIGN KEY (`category_output_printer_id`) REFERENCES `output_devices` (`id`);

ALTER TABLE `menus` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `menus` ADD FOREIGN KEY (`menu_set_id`) REFERENCES `menu_sets` (`id`);

ALTER TABLE `menu_options` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `menu_options` ADD FOREIGN KEY (`menu_buffet_id`) REFERENCES `menu_buffets` (`id`);
ALTER TABLE `menu_options` ADD FOREIGN KEY (`menu_set_id`) REFERENCES `menu_sets` (`id`);
ALTER TABLE `menu_options` ADD FOREIGN KEY (`menu_id`) REFERENCES `menus` (`id`);

ALTER TABLE `ingredients` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);

ALTER TABLE `ingredient_units` ADD FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`id`);

ALTER TABLE `menu_ingredients` ADD FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`id`);
ALTER TABLE `menu_ingredients` ADD FOREIGN KEY (`menu_id`) REFERENCES `menus` (`id`);

ALTER TABLE `stock_ingredients` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `stock_ingredients` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);
ALTER TABLE `stock_ingredients` ADD FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`id`);

ALTER TABLE `stock_ingredient_items` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `stock_ingredient_items` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);
ALTER TABLE `stock_ingredient_items` ADD FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`id`);
ALTER TABLE `stock_ingredient_items` ADD FOREIGN KEY (`stock_ingredient_id`) REFERENCES `stock_ingredients` (`id`);
ALTER TABLE `stock_ingredient_items` ADD FOREIGN KEY (`adjust_id`) REFERENCES `adjusts` (`id`);
ALTER TABLE `stock_ingredient_items` ADD FOREIGN KEY (`buy_id`) REFERENCES `buys` (`id`);

ALTER TABLE `dining_zone` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `dining_zone` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);

ALTER TABLE `dining_tables` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `dining_tables` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);
ALTER TABLE `dining_tables` ADD FOREIGN KEY (`dining_zone_id`) REFERENCES `dining_zone` (`id`);

ALTER TABLE `bill_numbers` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `bill_numbers` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);

ALTER TABLE `payment_methods` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);

ALTER TABLE `bill_payments` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `bill_payments` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);
ALTER TABLE `bill_payments` ADD FOREIGN KEY (`bill_id`) REFERENCES `bills` (`id`);
ALTER TABLE `bill_payments` ADD FOREIGN KEY (`payment_method_id`) REFERENCES `payment_methods` (`id`);

ALTER TABLE `order_channels` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);

ALTER TABLE `bills` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `bills` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);
ALTER TABLE `bills` ADD FOREIGN KEY (`dining_table_id`) REFERENCES `dining_tables` (`id`);
ALTER TABLE `bills` ADD FOREIGN KEY (`order_channels_id`) REFERENCES `order_channels` (`id`);

ALTER TABLE `bill_menu_buffets` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `bill_menu_buffets` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);
ALTER TABLE `bill_menu_buffets` ADD FOREIGN KEY (`bill_id`) REFERENCES `bills` (`id`);
ALTER TABLE `bill_menu_buffets` ADD FOREIGN KEY (`menu_buffet_id`) REFERENCES `menu_buffets` (`id`);

ALTER TABLE `bill_menu_sets` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `bill_menu_sets` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);
ALTER TABLE `bill_menu_sets` ADD FOREIGN KEY (`bill_id`) REFERENCES `bills` (`id`);
ALTER TABLE `bill_menu_sets` ADD FOREIGN KEY (`menu_buffet_id`) REFERENCES `menu_buffets` (`id`);
ALTER TABLE `bill_menu_sets` ADD FOREIGN KEY (`display_category_id`) REFERENCES `display_categorys` (`id`);

ALTER TABLE `bill_menus` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `bill_menus` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);
ALTER TABLE `bill_menus` ADD FOREIGN KEY (`bill_id`) REFERENCES `bills` (`id`);
ALTER TABLE `bill_menus` ADD FOREIGN KEY (`menu_buffet_id`) REFERENCES `menu_buffets` (`id`);
ALTER TABLE `bill_menus` ADD FOREIGN KEY (`bill_menu_set_id`) REFERENCES `bill_menu_sets` (`id`);

ALTER TABLE `bill_menu_options` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `bill_menu_options` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);
ALTER TABLE `bill_menu_options` ADD FOREIGN KEY (`bill_id`) REFERENCES `bills` (`id`);
ALTER TABLE `bill_menu_options` ADD FOREIGN KEY (`menu_buffet_id`) REFERENCES `menu_buffets` (`id`);
ALTER TABLE `bill_menu_options` ADD FOREIGN KEY (`bill_menu_set_id`) REFERENCES `bill_menu_sets` (`id`);
ALTER TABLE `bill_menu_options` ADD FOREIGN KEY (`bill_menu_id`) REFERENCES `bill_menus` (`id`);

ALTER TABLE `bill_menu_ingredients` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `bill_menu_ingredients` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);
ALTER TABLE `bill_menu_ingredients` ADD FOREIGN KEY (`bill_id`) REFERENCES `bills` (`id`);
ALTER TABLE `bill_menu_ingredients` ADD FOREIGN KEY (`menu_buffet_id`) REFERENCES `menu_buffets` (`id`);
ALTER TABLE `bill_menu_ingredients` ADD FOREIGN KEY (`bill_menu_set_id`) REFERENCES `bill_menu_sets` (`id`);
ALTER TABLE `bill_menu_ingredients` ADD FOREIGN KEY (`bill_menu_id`) REFERENCES `bill_menus` (`id`);
ALTER TABLE `bill_menu_ingredients` ADD FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`id`);

ALTER TABLE `buys` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `buys` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);

ALTER TABLE `buy_items` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `buy_items` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);
ALTER TABLE `buy_items` ADD FOREIGN KEY (`buy_id`) REFERENCES `buys` (`id`);
ALTER TABLE `buy_items` ADD FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`id`);

ALTER TABLE `buy_payment_notes` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `buy_payment_notes` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);
ALTER TABLE `buy_payment_notes` ADD FOREIGN KEY (`buy_id`) REFERENCES `buys` (`id`);

ALTER TABLE `adjusts` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `adjusts` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);

ALTER TABLE `adjust_items` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `adjust_items` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);
ALTER TABLE `adjust_items` ADD FOREIGN KEY (`adjust_id`) REFERENCES `adjusts` (`id`);
ALTER TABLE `adjust_items` ADD FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`id`);

ALTER TABLE `stock_removals` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `stock_removals` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);

ALTER TABLE `stock_removal_items` ADD FOREIGN KEY (`company_id`) REFERENCES `companys` (`id`);
ALTER TABLE `stock_removal_items` ADD FOREIGN KEY (`branch_id`) REFERENCES `branchs` (`id`);
ALTER TABLE `stock_removal_items` ADD FOREIGN KEY (`stock_removal_id`) REFERENCES `stock_removals` (`id`);
ALTER TABLE `stock_removal_items` ADD FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`id`);

ALTER TABLE `center_user_permissions` ADD FOREIGN KEY (`company_id`) REFERENCES `center_companys` (`id`);
ALTER TABLE `center_user_permissions` ADD FOREIGN KEY (`branch_id`) REFERENCES `center_branchs` (`id`);
ALTER TABLE `center_user_permissions` ADD FOREIGN KEY (`user_id`) REFERENCES `center_users` (`id`);
ALTER TABLE `center_user_permissions` ADD FOREIGN KEY (`permission_group_id`) REFERENCES `center_permission_groups` (`id`);
ALTER TABLE `center_user_permissions` ADD FOREIGN KEY (`permission_menu_id`) REFERENCES `center_permission_menus` (`id`);

ALTER TABLE `center_user_branch_permissions` ADD FOREIGN KEY (`user_id`) REFERENCES `center_users` (`id`);
ALTER TABLE `center_user_branch_permissions` ADD FOREIGN KEY (`company_id`) REFERENCES `center_companys` (`id`);
ALTER TABLE `center_user_branch_permissions` ADD FOREIGN KEY (`branch_id`) REFERENCES `center_branchs` (`id`);

ALTER TABLE `center_user_tokens` ADD FOREIGN KEY (`user_id`) REFERENCES `center_users` (`id`);

ALTER TABLE `center_users` ADD FOREIGN KEY (`center_company_id`) REFERENCES `center_companys` (`id`);

ALTER TABLE `center_company_types` ADD FOREIGN KEY (`center_company_id`) REFERENCES `center_companys` (`id`);
ALTER TABLE `center_company_types` ADD FOREIGN KEY (`center_restaurant_type_id`) REFERENCES `center_restaurant_types` (`id`);

ALTER TABLE `center_company_review_comments` ADD FOREIGN KEY (`center_company_id`) REFERENCES `center_companys` (`id`);
ALTER TABLE `center_company_review_comments` ADD FOREIGN KEY (`center_branch_id`) REFERENCES `center_branchs` (`id`);
ALTER TABLE `center_company_review_comments` ADD FOREIGN KEY (`center_customer_id`) REFERENCES `center_customers` (`id`);

ALTER TABLE `center_branchs` ADD FOREIGN KEY (`center_company_id`) REFERENCES `center_companys` (`id`);

ALTER TABLE `center_customer_bookings` ADD FOREIGN KEY (`center_company_id`) REFERENCES `center_companys` (`id`);
ALTER TABLE `center_customer_bookings` ADD FOREIGN KEY (`center_branch_id`) REFERENCES `center_branchs` (`id`);
ALTER TABLE `center_customer_bookings` ADD FOREIGN KEY (`center_customer_id`) REFERENCES `center_customers` (`id`);

ALTER TABLE `center_customer_bill_histories` ADD FOREIGN KEY (`center_customer_id`) REFERENCES `center_customers` (`id`);
ALTER TABLE `center_customer_bill_histories` ADD FOREIGN KEY (`center_company_id`) REFERENCES `center_companys` (`id`);
ALTER TABLE `center_customer_bill_histories` ADD FOREIGN KEY (`center_branch_id`) REFERENCES `center_branchs` (`id`);

ALTER TABLE `center_point_histories` ADD FOREIGN KEY (`center_customer_id`) REFERENCES `center_customers` (`id`);
ALTER TABLE `center_point_histories` ADD FOREIGN KEY (`center_customer_bill_history_id`) REFERENCES `center_customer_bill_histories` (`id`);
ALTER TABLE `center_point_histories` ADD FOREIGN KEY (`center_company_id`) REFERENCES `center_companys` (`id`);
ALTER TABLE `center_point_histories` ADD FOREIGN KEY (`center_branch_id`) REFERENCES `center_branchs` (`id`);
