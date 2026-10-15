-- Tạo cơ sở dữ liệu
CREATE DATABASE QuanLyBenhVien;
GO
USE QuanLyBenhVien;
GO

-- 1. Bảng Khoa
CREATE TABLE Khoa (
    MaKhoa VARCHAR(10) PRIMARY KEY,
    TenKhoa NVARCHAR(100) UNIQUE NOT NULL,
    DienThoai VARCHAR(15),
    Email VARCHAR(100)
);
GO

-- 2. Bảng BacSi
CREATE TABLE BacSi (
    MaBS VARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    SDT VARCHAR(15) UNIQUE,
    Email VARCHAR(100),
    MaKhoa VARCHAR(10),
    FOREIGN KEY (MaKhoa) REFERENCES Khoa(MaKhoa)
);
GO

-- 3. Bảng BenhNhan
CREATE TABLE BenhNhan (
    MaBN VARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    SDT VARCHAR(15),
    DiaChi NVARCHAR(250),
    NgayTao DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- 4. Bảng LichKham
CREATE TABLE LichKham (
    MaLK VARCHAR(10) PRIMARY KEY,
    MaBN VARCHAR(10),
    MaBS VARCHAR(10),
    ThoiGianKham DATETIME2,
    LyDo NVARCHAR(250),
    TrangThai NVARCHAR(20) CHECK (TrangThai IN (N'Chờ khám', N'Đang khám', N'Đã khám', N'Đã hủy')),
    FOREIGN KEY (MaBN) REFERENCES BenhNhan(MaBN),
    FOREIGN KEY (MaBS) REFERENCES BacSi(MaBS)
);
GO

-- 5. Bảng HoSoBenhAn
CREATE TABLE HoSoBenhAn (
    MaBA VARCHAR(10) PRIMARY KEY,
    MaLK VARCHAR(10) UNIQUE, -- Mỗi lịch khám tối đa một bệnh án
    NgayLap DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    TrieuChung NVARCHAR(MAX),
    ChanDoan NVARCHAR(500),
    KetLuan NVARCHAR(1000),
    FOREIGN KEY (MaLK) REFERENCES LichKham(MaLK)
);
GO

-- 6. Bảng DonThuoc
CREATE TABLE DonThuoc (
    MaDT VARCHAR(10) PRIMARY KEY,
    MaBA VARCHAR(10),
    NgayKe DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    GhiChu NVARCHAR(500),
    FOREIGN KEY (MaBA) REFERENCES HoSoBenhAn(MaBA)
);
GO

-- 7. Bảng Thuoc
CREATE TABLE Thuoc (
    MaThuoc VARCHAR(10) PRIMARY KEY,
    TenThuoc NVARCHAR(150) NOT NULL,
    DonVi NVARCHAR(30),
    DonGia DECIMAL(18,2) CHECK (DonGia >= 0),
    SoLuongTon INT CHECK (SoLuongTon >= 0)
);
GO

-- 8. Bảng ChiTietDonThuoc
CREATE TABLE ChiTietDonThuoc (
    MaDT VARCHAR(10),
    MaThuoc VARCHAR(10),
    LieuDung NVARCHAR(250),
    SoLuong INT CHECK (SoLuong > 0),
    DonGiaKe DECIMAL(18,2) CHECK (DonGiaKe >= 0),
    PRIMARY KEY (MaDT, MaThuoc),
    FOREIGN KEY (MaDT) REFERENCES DonThuoc(MaDT),
    FOREIGN KEY (MaThuoc) REFERENCES Thuoc(MaThuoc)
);
GO

-- 9. Bảng DichVu
CREATE TABLE DichVu (
    MaDV VARCHAR(10) PRIMARY KEY,
    TenDV NVARCHAR(150) UNIQUE NOT NULL,
    DonGia DECIMAL(18,2) CHECK (DonGia >= 0),
    MoTa NVARCHAR(500)
);
GO

-- 10. Bảng ChiTietDichVu
CREATE TABLE ChiTietDichVu (
    MaBA VARCHAR(10),
    MaDV VARCHAR(10),
    LanThucHien INT,
    SoLuong INT CHECK (SoLuong > 0),
    DonGiaApDung DECIMAL(18,2) CHECK (DonGiaApDung >= 0),
    NgayThucHien DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (MaBA, MaDV, LanThucHien),
    FOREIGN KEY (MaBA) REFERENCES HoSoBenhAn(MaBA),
    FOREIGN KEY (MaDV) REFERENCES DichVu(MaDV)
);
GO

-- 11. Bảng HoaDon
CREATE TABLE HoaDon (
    MaHD VARCHAR(10) PRIMARY KEY,
    MaBA VARCHAR(10) UNIQUE, -- Mỗi bệnh án tối đa một hóa đơn
    NgayLap DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    TongTien DECIMAL(18,2) CHECK (TongTien >= 0),
    TrangThai NVARCHAR(20) CHECK (TrangThai IN (N'Chưa thanh toán', N'Đã thanh toán', N'Đã hủy')),
    FOREIGN KEY (MaBA) REFERENCES HoSoBenhAn(MaBA)
);
GO