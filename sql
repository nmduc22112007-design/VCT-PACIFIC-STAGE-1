/* ================================
   PHẦN 0: Tạo Database & dùng DB
   ================================*/
IF DB_ID(N'VPP_StoreDB') IS NOT NULL
BEGIN
    ALTER DATABASE VPP_StoreDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE VPP_StoreDB;
END;
GO

CREATE DATABASE VPP_StoreDB;
GO
USE VPP_StoreDB;
GO

/* ================================
   PHẦN 1: Tạo Bảng & Ràng buộc
   ================================*/
-- Nhà cung cấp
CREATE TABLE dbo.NhaCungCap (
    SupplierID      INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName    NVARCHAR(200) NOT NULL,
    Address         NVARCHAR(300) NULL,
    Phone           NVARCHAR(30) NULL,
    CONSTRAINT UQ_NCC_Name UNIQUE (SupplierName)
);

-- Khách hàng
CREATE TABLE dbo.KhachHang (
    CustomerID      INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName    NVARCHAR(200) NOT NULL,
    Address         NVARCHAR(300) NULL,
    Phone           NVARCHAR(30) NULL
);

-- Sản phẩm
CREATE TABLE dbo.SanPham (
    ProductID       INT IDENTITY(1,1) PRIMARY KEY,
    ProductCode     NVARCHAR(50) NOT NULL UNIQUE,
    ProductName     NVARCHAR(200) NOT NULL,
    Origin          NVARCHAR(100) NULL,    -- nơi sản xuất
    Unit            NVARCHAR(50)  NOT NULL DEFAULT(N'cái')
);

-- Tồn kho
CREATE TABLE dbo.TonKho (
    ProductID       INT PRIMARY KEY
        CONSTRAINT FK_TonKho_SanPham REFERENCES dbo.SanPham(ProductID) ON DELETE CASCADE,
    OnHand          INT NOT NULL DEFAULT(0) 
        CONSTRAINT CK_TonKho_OnHand CHECK (OnHand >= 0),
    LastUpdated     DATETIME NOT NULL DEFAULT(GETDATE())
);

-- Hóa đơn nhập (phiếu nhập)
CREATE TABLE dbo.HoaDonNhap (
    POID            INT IDENTITY(1,1) PRIMARY KEY,
    PONumber        NVARCHAR(30) NOT NULL UNIQUE,
    SupplierID      INT NOT NULL
        CONSTRAINT FK_HDN_NCC REFERENCES dbo.NhaCungCap(SupplierID),
    OrderDate       DATE NOT NULL
);

-- Chi tiết hóa đơn nhập
CREATE TABLE dbo.CT_HoaDonNhap (
    POID            INT NOT NULL
        CONSTRAINT FK_CTHDN_HDN REFERENCES dbo.HoaDonNhap(POID) ON DELETE CASCADE,
    ProductID       INT NOT NULL
        CONSTRAINT FK_CTHDN_SP REFERENCES dbo.SanPham(ProductID),
    Quantity        INT NOT NULL
        CONSTRAINT CK_CTHDN_Qty CHECK (Quantity > 0),
    UnitCost        DECIMAL(18,2) NOT NULL
        CONSTRAINT CK_CTHDN_Cost CHECK (UnitCost > 0),
    CONSTRAINT PK_CTHDN PRIMARY KEY (POID, ProductID)
);

-- Hóa đơn bán (hóa đơn)
CREATE TABLE dbo.HoaDonBan (
    SOID            INT IDENTITY(1,1) PRIMARY KEY,
    SONumber        NVARCHAR(30) NOT NULL UNIQUE,
    CustomerID      INT NOT NULL
        CONSTRAINT FK_HDB_KH REFERENCES dbo.KhachHang(CustomerID),
    OrderDate       DATE NOT NULL
);

-- Chi tiết hóa đơn bán
CREATE TABLE dbo.CT_HoaDonBan (
    SOID            INT NOT NULL
        CONSTRAINT FK_CTHDB_HDB REFERENCES dbo.HoaDonBan(SOID) ON DELETE CASCADE,
    ProductID       INT NOT NULL
        CONSTRAINT FK_CTHDB_SP REFERENCES dbo.SanPham(ProductID),
    Quantity        INT NOT NULL
        CONSTRAINT CK_CTHDB_Qty CHECK (Quantity > 0),
    UnitPrice       DECIMAL(18,2) NOT NULL
        CONSTRAINT CK_CTHDB_Price CHECK (UnitPrice > 0),
    CONSTRAINT PK_CTHDB PRIMARY KEY (SOID, ProductID)
);

-- Chỉ mục gợi ý hiệu năng
CREATE INDEX IX_SP_Origin ON dbo.SanPham(Origin);
CREATE INDEX IX_HDN_Date  ON dbo.HoaDonNhap(OrderDate);
CREATE INDEX IX_HDB_Date  ON dbo.HoaDonBan(OrderDate);
CREATE INDEX IX_CTHDN_Product ON dbo.CT_HoaDonNhap(ProductID);
CREATE INDEX IX_CTHDB_Product ON dbo.CT_HoaDonBan(ProductID);
GO

/* ============================================
   PHẦN 2: DỮ LIỆU DEMO (≥ 20 bản ghi mỗi bảng)
   ============================================*/
-- 2.1 Nhà cung cấp (20)
INSERT INTO dbo.NhaCungCap (SupplierName, Address, Phone) VALUES
(N'VPP Ánh Dương', N'Q.1, TP.HCM', N'0901000001'),
(N'VPP Bình Minh', N'Q.3, TP.HCM', N'0901000002'),
(N'VPP Cửu Long', N'Ninh Kiều, Cần Thơ', N'0901000003'),
(N'VPP Đại Nam', N'Q.5, TP.HCM', N'0901000004'),
(N'VPP Everest', N'Q.10, TP.HCM', N'0901000005'),
(N'VPP Fami', N'Q.7, TP.HCM', N'0901000006'),
(N'VPP Gấu Trúc', N'TP. Thủ Đức', N'0901000007'),
(N'VPP Hồng Hà', N'Hoàn Kiếm, Hà Nội', N'0901000008'),
(N'VPP Ivy', N'Đống Đa, Hà Nội', N'0901000009'),
(N'VPP JK', N'Q. Tân Bình, TP.HCM', N'0901000010'),
(N'VPP Kibi', N'Hải Châu, Đà Nẵng', N'0901000011'),
(N'VPP Lạc Việt', N'Q. Phú Nhuận, TP.HCM', N'0901000012'),
(N'VPP Minh Long', N'Q. Bình Thạnh, TP.HCM', N'0901000013'),
(N'VPP Nhật Quang', N'Q.8, TP.HCM', N'0901000014'),
(N'VPP Ocean', N'Cầu Giấy, Hà Nội', N'0901000015'),
(N'VPP Phương Nam', N'Q.11, TP.HCM', N'0901000016'),
(N'VPP Queen', N'Liên Chiểu, Đà Nẵng', N'0901000017'),
(N'VPP Rainbow', N'Long Biên, Hà Nội', N'0901000018'),
(N'VPP Sakura', N'Bắc Từ Liêm, Hà Nội', N'0901000019'),
(N'VPP Thiên Long', N'Thủ Dầu Một, Bình Dương', N'0901000020');

-- 2.2 Khách hàng (20)
INSERT INTO dbo.KhachHang (CustomerName, Address, Phone) VALUES
(N'Nguyễn Văn A', N'Q.1, TP.HCM', N'0912000001'),
(N'Trần Thị B', N'Q.3, TP.HCM', N'0912000002'),
(N'Lê Văn C', N'Q.5, TP.HCM', N'0912000003'),
(N'Phạm Thị D', N'Đống Đa, Hà Nội', N'0912000004'),
(N'Hoàng Văn E', N'Cầu Giấy, Hà Nội', N'0912000005'),
(N'Vũ Thị F', N'Hải Châu, Đà Nẵng', N'0912000006'),
(N'Bùi Văn G', N'Nha Trang', N'0912000007'),
(N'Đỗ Thị H', N'Vũng Tàu', N'0912000008'),
(N'Phan Văn I', N'Biên Hòa', N'0912000009'),
(N'Ngô Thị K', N'Thủ Đức', N'0912000010'),
(N'Đặng Văn L', N'Bình Dương', N'0912000011'),
(N'Nguyễn Thị M', N'Cần Thơ', N'0912000012'),
(N'Trương Văn N', N'Long An', N'0912000013'),
(N'Võ Thị O', N'Đà Lạt', N'0912000014'),
(N'Đỗ Văn P', N'Huế', N'0912000015'),
(N'Phùng Thị Q', N'Quảng Ninh', N'0912000016'),
(N'Châu Văn R', N'Bắc Ninh', N'0912000017'),
(N'Tạ Thị S', N'Nam Định', N'0912000018'),
(N'Lý Văn T', N'Thanh Hóa', N'0912000019'),
(N'Hà Thị U', N'Hải Phòng', N'0912000020');

-- 2.3 Sản phẩm (20)
INSERT INTO dbo.SanPham (ProductCode, ProductName, Origin, Unit) VALUES
(N'P001', N'Bút bi xanh TL-01', N'Việt Nam', N'cây'),
(N'P002', N'Bút bi đen TL-02', N'Việt Nam', N'cây'),
(N'P003', N'Bút chì 2B', N'Thái Lan', N'cây'),
(N'P004', N'Bút dạ quang vàng', N'Trung Quốc', N'cây'),
(N'P005', N'Gôm tẩy HB', N'Việt Nam', N'cục'),
(N'P006', N'Compa học sinh', N'Trung Quốc', N'cái'),
(N'P007', N'Thước kẻ 20cm', N'Việt Nam', N'cái'),
(N'P008', N'Sổ tay A5 100 trang', N'Việt Nam', N'cuốn'),
(N'P009', N'Sổ lò xo B5', N'Việt Nam', N'cuốn'),
(N'P010', N'Giấy A4 70gsm', N'Indonesia', N'ram'),
(N'P011', N'Giấy A4 80gsm', N'Indonesia', N'ram'),
(N'P012', N'Bìa hồ sơ còng A4', N'Trung Quốc', N'cái'),
(N'P013', N'Kẹp bướm 32mm', N'Thái Lan', N'hộp'),
(N'P014', N'Ghim bấm số 10', N'Việt Nam', N'hộp'),
(N'P015', N'Bấm kim số 10', N'Trung Quốc', N'cái'),
(N'P016', N'Máy tính Casio FX-570', N'Nhật Bản', N'cái'),
(N'P017', N'Bảng trắng mini', N'Việt Nam', N'cái'),
(N'P018', N'Mực dấu xanh', N'Trung Quốc', N'chai'),
(N'P019', N'Bút lông bảng', N'Việt Nam', N'cây'),
(N'P020', N'Keo dán giấy', N'Việt Nam', N'chai');

-- 2.4 Khởi tạo tồn kho (0) cho tất cả sản phẩm
INSERT INTO dbo.TonKho (ProductID, OnHand)
SELECT ProductID, 0 FROM dbo.SanPham;

-- 2.5 Tạo hóa đơn nhập (20 header)
;WITH D AS (
    SELECT TOP (20)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM sys.objects
)
INSERT INTO dbo.HoaDonNhap (PONumber, SupplierID, OrderDate)
SELECT
    CONCAT(N'PN', FORMAT(rn, 'D4')),
    ((rn - 1) % 20) + 1,
    DATEFROMPARTS(2026, CASE WHEN rn <= 10 THEN 1 ELSE 2 END, (rn % 28) + 1)
FROM D;

-- 2.6 CT hóa đơn nhập (mỗi PN nhập 3 mặt hàng = 60 dòng)
-- Số lượng nhập ~ 50-99; Giá nhập ~ 5,000 - 7,000
INSERT INTO dbo.CT_HoaDonNhap (POID, ProductID, Quantity, UnitCost)
SELECT
    P.POID,
    ((P.POID - 1 + O.OffsetVal) % 20) + 1 AS ProductID,
    50 + ((P.POID + O.OffsetVal) % 50) AS Quantity,
    5000 + (((P.POID + O.OffsetVal) % 20) * 100) AS UnitCost
FROM dbo.HoaDonNhap AS P
CROSS JOIN (VALUES (0),(5),(10)) AS O(OffsetVal);

-- 2.7 Tạo hóa đơn bán (20 header)
;WITH D2 AS (
    SELECT TOP (20)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM sys.objects
)
INSERT INTO dbo.HoaDonBan (SONumber, CustomerID, OrderDate)
SELECT
    CONCAT(N'HD', FORMAT(rn, 'D4')),
    ((rn - 1) % 20) + 1,
    DATEFROMPARTS(2026, CASE WHEN rn <= 10 THEN 1 ELSE 2 END, (rn % 28) + 1)
FROM D2;

-- 2.8 CT hóa đơn bán (mỗi HĐ bán 3 mặt hàng = 60 dòng)
-- Số lượng bán ~ 5-25; Giá bán ~ 8,000 - 12,000
INSERT INTO dbo.CT_HoaDonBan (SOID, ProductID, Quantity, UnitPrice)
SELECT
    S.SOID,
    ((S.SOID - 1 + O.OffsetVal) % 20) + 1 AS ProductID,
    5 + ((S.SOID + O.OffsetVal) % 21)   AS Quantity,
    8000 + (((S.SOID + O.OffsetVal) % 40) * 100) AS UnitPrice
FROM dbo.HoaDonBan AS S
CROSS JOIN (VALUES (0),(7),(13)) AS O(OffsetVal);

-- Lưu ý: triggers cập nhật tồn kho sẽ được tạo bên dưới,
-- nhưng để demo predictable, ta tạo trigger trước khi insert chi tiết.
-- ==> Nếu bạn chạy toàn bộ script 1 lần, hãy DI CHUYỂN khối triggers lên ngay trước 2.6 và 2.8.
GO

/* ====================================
   PHẦN 3: TRIGGERS tự động cập nhật kho
   ====================================*/
-- Trigger cộng kho khi nhập (insert/update/delete chi tiết PN)
DROP TRIGGER IF EXISTS dbo.TR_CTHDN_UpdateInventory;
GO
CREATE TRIGGER dbo.TR_CTHDN_UpdateInventory
ON dbo.CT_HoaDonNhap
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Delta = inserted - deleted
    ;WITH changes AS (
        SELECT ProductID, SUM(Quantity) AS Qty
        FROM inserted
        GROUP BY ProductID
        UNION ALL
        SELECT ProductID, -SUM(Quantity) AS Qty
        FROM deleted
        GROUP BY ProductID
    ),
    agg as (
        SELECT ProductID, SUM(Qty) AS QtyDelta
        FROM changes
        GROUP BY ProductID
    )
    UPDATE TK
        SET TK.OnHand = TK.OnHand + A.QtyDelta,
            TK.LastUpdated = GETDATE()
    FROM dbo.TonKho AS TK
    JOIN agg AS A ON A.ProductID = TK.ProductID;

    -- Không cho phép âm kho
    IF EXISTS (
        SELECT 1 FROM dbo.TonKho WHERE OnHand < 0
    )
    BEGIN
        RAISERROR (N'Số lượng tồn kho âm sau khi nhập/cập nhật/rollback.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

-- Trigger trừ kho khi bán (insert/update/delete chi tiết HĐ bán)
DROP TRIGGER IF EXISTS dbo.TR_CTHDB_UpdateInventory;
GO
CREATE TRIGGER dbo.TR_CTHDB_UpdateInventory
ON dbo.CT_HoaDonBan
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH changes AS (
        SELECT ProductID, SUM(Quantity) AS Qty FROM inserted GROUP BY ProductID
        UNION ALL
        SELECT ProductID, -SUM(Quantity) AS Qty FROM deleted GROUP BY ProductID
    ),
    agg AS (
        SELECT ProductID, SUM(Qty) AS QtyDelta FROM changes GROUP BY ProductID
    )
    UPDATE TK
        SET TK.OnHand = TK.OnHand - A.QtyDelta,   -- bán => trừ
            TK.LastUpdated = GETDATE()
    FROM dbo.TonKho AS TK
    JOIN agg AS A ON A.ProductID = TK.ProductID;

    IF EXISTS (
        SELECT 1 FROM dbo.TonKho WHERE OnHand < 0
    )
    BEGIN
        RAISERROR (N'Tồn kho không đủ để bán (âm kho).', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

/* ===================================================
   PHẦN 4: VIEWS (tối thiểu 03 View)
   ===================================================*/
-- 4.1. View tồn kho hiện tại (kèm thông tin sản phẩm)
CREATE OR ALTER VIEW dbo.vw_TonKhoHienTai
AS
SELECT 
    sp.ProductID,
    sp.ProductCode,
    sp.ProductName,
    sp.Origin,
    sp.Unit,
    tk.OnHand,
    tk.LastUpdated
FROM dbo.SanPham sp
JOIN dbo.TonKho tk ON sp.ProductID = tk.ProductID;
GO

-- 4.2. View doanh số bán theo tháng (theo sản phẩm)
CREATE OR ALTER VIEW dbo.vw_DoanhSoTheoThang
AS
SELECT
    sp.ProductID,
    sp.ProductCode,
    sp.ProductName,
    YEAR(hd.OrderDate) AS Nam,
    MONTH(hd.OrderDate) AS Thang,
    SUM(ct.Quantity) AS TongSoLuong,
    SUM(ct.Quantity * ct.UnitPrice) AS DoanhThu
FROM dbo.CT_HoaDonBan ct
JOIN dbo.HoaDonBan hd ON hd.SOID = ct.SOID
JOIN dbo.SanPham sp ON sp.ProductID = ct.ProductID
GROUP BY sp.ProductID, sp.ProductCode, sp.ProductName, YEAR(hd.OrderDate), MONTH(hd.OrderDate);
GO

-- 4.3. View top khách hàng theo tháng (doanh thu)
CREATE OR ALTER VIEW dbo.vw_TopKhachHangThang
AS
SELECT
    kh.CustomerID,
    kh.CustomerName,
    YEAR(hd.OrderDate) AS Nam,
    MONTH(hd.OrderDate) AS Thang,
    SUM(ct.Quantity * ct.UnitPrice) AS DoanhThu
FROM dbo.KhachHang kh
JOIN dbo.HoaDonBan hd ON hd.CustomerID = kh.CustomerID
JOIN dbo.CT_HoaDonBan ct ON ct.SOID = hd.SOID
GROUP BY kh.CustomerID, kh.CustomerName, YEAR(hd.OrderDate), MONTH(hd.OrderDate);
GO

/* ===================================================
   PHẦN 5: FUNCTIONS (tối thiểu 03 Function)
   ===================================================*/
-- 5.1. Ngày đầu tháng
CREATE OR ALTER FUNCTION dbo.fn_FirstDateOfMonth(@Year INT, @Month INT)
RETURNS DATE
AS
BEGIN
    RETURN DATEFROMPARTS(@Year, @Month, 1);
END;
GO

-- 5.2. Doanh thu 1 khách hàng trong tháng
CREATE OR ALTER FUNCTION dbo.fn_DoanhThuKhachHangTrongThang
(
    @CustomerID INT, 
    @Year INT, 
    @Month INT
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @rev DECIMAL(18,2);
    SELECT @rev = ISNULL(SUM(ct.Quantity * ct.UnitPrice), 0)
    FROM dbo.HoaDonBan hd
    JOIN dbo.CT_HoaDonBan ct ON ct.SOID = hd.SOID
    WHERE hd.CustomerID = @CustomerID
      AND YEAR(hd.OrderDate) = @Year
      AND MONTH(hd.OrderDate) = @Month;
    RETURN @rev;
END;
GO

-- 5.3. Danh sách sản phẩm không bán trong tháng (TVF)
CREATE OR ALTER FUNCTION dbo.fn_SanPhamKhongBanTrongThang
(
    @Year INT,
    @Month INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT sp.ProductID, sp.ProductCode, sp.ProductName, sp.Origin
    FROM dbo.SanPham sp
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.HoaDonBan hd
        JOIN dbo.CT_HoaDonBan ct ON ct.SOID = hd.SOID
        WHERE ct.ProductID = sp.ProductID
          AND YEAR(hd.OrderDate) = @Year
          AND MONTH(hd.OrderDate) = @Month
    )
);
GO

/* ===================================================
   PHẦN 6: STORED PROCEDURES (tối thiểu 03 SP)
   ===================================================*/
-- 6.1. Tìm kiếm văn phòng phẩm theo nơi sản xuất hoặc theo nhà cung cấp (qua lịch sử nhập)
CREATE OR ALTER PROCEDURE dbo.sp_TimKiemVanPhongPham
    @NoiSanXuat NVARCHAR(100) = NULL,
    @SupplierID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Theo nơi sản xuất
    IF @NoiSanXuat IS NOT NULL
    BEGIN
        SELECT sp.*
        FROM dbo.SanPham sp
        WHERE sp.Origin = @NoiSanXuat;
    END

    -- Theo nhà cung cấp (dựa trên phiếu nhập)
    IF @SupplierID IS NOT NULL
    BEGIN
        SELECT DISTINCT sp.*
        FROM dbo.SanPham sp
        JOIN dbo.CT_HoaDonNhap ct ON ct.ProductID = sp.ProductID
        JOIN dbo.HoaDonNhap hd ON hd.POID = ct.POID
        WHERE hd.SupplierID = @SupplierID;
    END
END;
GO

-- 6.2. Tìm nhà cung cấp theo ngày nhập (khoảng) hoặc theo sản phẩm
CREATE OR ALTER PROCEDURE dbo.sp_TimNhaCungCap
    @FromDate DATE = NULL,
    @ToDate   DATE = NULL,
    @ProductID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Theo ngày nhập
    IF @FromDate IS NOT NULL AND @ToDate IS NOT NULL
    BEGIN
        SELECT DISTINCT ncc.*
        FROM dbo.NhaCungCap ncc
        JOIN dbo.HoaDonNhap hd ON hd.SupplierID = ncc.SupplierID
        WHERE hd.OrderDate BETWEEN @FromDate AND @ToDate
        ORDER BY ncc.SupplierName;
    END

    -- Theo sản phẩm đã cung cấp (từng xuất hiện trong phiếu nhập)
    IF @ProductID IS NOT NULL
    BEGIN
        SELECT DISTINCT ncc.*
        FROM dbo.NhaCungCap ncc
        JOIN dbo.HoaDonNhap hd ON hd.SupplierID = ncc.SupplierID
        JOIN dbo.CT_HoaDonNhap ct ON ct.POID = hd.POID
        WHERE ct.ProductID = @ProductID
        ORDER BY ncc.SupplierName;
    END
END;
GO

-- 6.3. Top bán & Không bán trong tháng
CREATE OR ALTER PROCEDURE dbo.sp_BaoCao_TopBanVaKhongBanTrongThang
    @Year INT, @Month INT, @TopN INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    -- KQ1: Top @TopN sản phẩm bán nhiều theo số lượng
    SELECT TOP (@TopN)
        sp.ProductID, sp.ProductCode, sp.ProductName,
        SUM(ct.Quantity) AS TongSoLuong,
        SUM(ct.Quantity * ct.UnitPrice) AS DoanhThu
    FROM dbo.SanPham sp
    JOIN dbo.CT_HoaDonBan ct ON ct.ProductID = sp.ProductID
    JOIN dbo.HoaDonBan hd ON hd.SOID = ct.SOID
    WHERE YEAR(hd.OrderDate) = @Year AND MONTH(hd.OrderDate) = @Month
    GROUP BY sp.ProductID, sp.ProductCode, sp.ProductName
    ORDER BY TongSoLuong DESC;

    -- KQ2: Danh sách sản phẩm không bán trong tháng
    SELECT * FROM dbo.fn_SanPhamKhongBanTrongThang(@Year, @Month);
END;
GO
/* ===================================================
   PHẦN 7: TRUY VẤN MẪU THEO YÊU CẦU NGHIỆP VỤ
   ===================================================*/
-- 7.1 Tìm kiếm thông tin văn phòng phẩm theo nơi sản xuất
-- Ví dụ: nơi sản xuất = 'Việt Nam'
-- SELECT * FROM dbo.SanPham WHERE Origin = N'Việt Nam';

-- 7.2 Tìm kiếm thông tin văn phòng phẩm theo nhà cung cấp (dựa vào lịch sử nhập)
-- DECLARE @ncc INT = 1;
-- SELECT DISTINCT sp.*
-- FROM dbo.SanPham sp
-- JOIN dbo.CT_HoaDonNhap ct ON ct.ProductID = sp.ProductID
-- JOIN dbo.HoaDonNhap hd ON hd.POID = ct.POID
-- WHERE hd.SupplierID = @ncc;

-- 7.3 Tìm nhà cung cấp theo ngày nhập
-- SELECT DISTINCT ncc.*
-- FROM dbo.NhaCungCap ncc
-- JOIN dbo.HoaDonNhap hd ON hd.SupplierID = ncc.SupplierID
-- WHERE hd.OrderDate BETWEEN '2026-01-01' AND '2026-01-31';

-- 7.4 Tìm nhà cung cấp theo sản phẩm
-- DECLARE @pid INT = 5;
-- SELECT DISTINCT ncc.*
-- FROM dbo.NhaCungCap ncc
-- JOIN dbo.HoaDonNhap hd ON hd.SupplierID = ncc.SupplierID
-- JOIN dbo.CT_HoaDonNhap ct ON ct.POID = hd.POID
-- WHERE ct.ProductID = @pid;

-- 7.5 Danh sách văn phòng phẩm theo nơi sản xuất (group)
-- SELECT Origin, COUNT(*) AS SoMatHang
-- FROM dbo.SanPham
-- GROUP BY Origin
-- ORDER BY SoMatHang DESC;

-- 7.6 Mặt hàng bán được nhiều nhất trong tháng (ví dụ 2026-02)
-- SELECT TOP 10 sp.ProductID, sp.ProductName, SUM(ct.Quantity) AS SLBan
-- FROM dbo.CT_HoaDonBan ct
-- JOIN dbo.HoaDonBan hd ON hd.SOID = ct.SOID
-- JOIN dbo.SanPham sp ON sp.ProductID = ct.ProductID
-- WHERE YEAR(hd.OrderDate) = 2026 AND MONTH(hd.OrderDate) = 2
-- GROUP BY sp.ProductID, sp.ProductName
-- ORDER BY SLBan DESC;

-- 7.7 Mặt hàng không bán trong tháng
-- SELECT * FROM dbo.fn_SanPhamKhongBanTrongThang(2026, 2);

-- 7.8 Doanh số bán hàng theo tháng của từng loại văn phòng phẩm
-- SELECT * FROM dbo.vw_DoanhSoTheoThang WHERE Nam = 2026;

-- 7.9 Khách hàng mua nhiều loại mặt hàng theo tháng (đếm số loại distinct)
-- SELECT TOP 10 kh.CustomerID, kh.CustomerName,
--        YEAR(hd.OrderDate) AS Nam, MONTH(hd.OrderDate) AS Thang,
--        COUNT(DISTINCT ct.ProductID) AS SoLoaiMatHang
-- FROM dbo.KhachHang kh
-- JOIN dbo.HoaDonBan hd ON hd.CustomerID = kh.CustomerID
-- JOIN dbo.CT_HoaDonBan ct ON ct.SOID = hd.SOID
-- WHERE YEAR(hd.OrderDate) = 2026 AND MONTH(hd.OrderDate) = 2
-- GROUP BY kh.CustomerID, kh.CustomerName, YEAR(hd.OrderDate), MONTH(hd.OrderDate)
-- ORDER BY SoLoaiMatHang DESC;

-- 7.10 Khách hàng mang lại doanh thu lớn nhất trong tháng
-- SELECT TOP 1 kh.CustomerID, kh.CustomerName,
--        SUM(ct.Quantity * ct.UnitPrice) AS DoanhThu
-- FROM dbo.KhachHang kh
-- JOIN dbo.HoaDonBan hd ON hd.CustomerID = kh.CustomerID
-- JOIN dbo.CT_HoaDonBan ct ON ct.SOID = hd.SOID
-- WHERE YEAR(hd.OrderDate) = 2026 AND MONTH(hd.OrderDate) = 2
-- GROUP BY kh.CustomerID, kh.CustomerName
-- ORDER BY DoanhThu DESC;

-- 7.11 Báo cáo danh sách mặt hàng tồn kho hiện tại
-- SELECT * FROM dbo.vw_TonKhoHienTai ORDER BY OnHand DESC;

-- 7.12 Báo cáo nhà cung cấp và số lượng mặt hàng đã cung cấp trong tháng/năm
-- SELECT ncc.SupplierID, ncc.SupplierName, YEAR(hd.OrderDate) AS Nam, MONTH(hd.OrderDate) AS Thang,
--        COUNT(DISTINCT ct.ProductID) AS SoMatHang,
--        SUM(ct.Quantity) AS TongSoLuongNhap
-- FROM dbo.NhaCungCap ncc
-- JOIN dbo.HoaDonNhap hd ON hd.SupplierID = ncc.SupplierID
-- JOIN dbo.CT_HoaDonNhap ct ON ct.POID = hd.POID
-- WHERE YEAR(hd.OrderDate) = 2026 AND MONTH(hd.OrderDate) = 2
-- GROUP BY ncc.SupplierID, ncc.SupplierName, YEAR(hd.OrderDate), MONTH(hd.OrderDate)
-- ORDER BY TongSoLuongNhap DESC;
GO
/* ===================================================
   KẾT THÚC SCRIPT
   ===================================================*/