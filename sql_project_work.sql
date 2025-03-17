-- Select the database
create database lb;
USE lb;
-- Create Publisher Table
CREATE TABLE tbl_publisher (
    publisher_PublisherName VARCHAR(255) PRIMARY KEY,
    publisher_PublisherAddress TEXT,
    publisher_PublisherPhone VARCHAR(20)
);

-- Create Book Table (with foreign key to Publisher)
CREATE TABLE tbl_book (
    book_BookID INT AUTO_INCREMENT PRIMARY KEY,
    book_Title VARCHAR(255),
    book_PublisherName VARCHAR(255),
    FOREIGN KEY (book_PublisherName) REFERENCES tbl_publisher(publisher_PublisherName) ON DELETE CASCADE
);

-- Create Book Authors Table (with foreign key to Book)
CREATE TABLE tbl_book_authors (
    book_authors_AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    book_authors_BookID INT,
    book_authors_AuthorName VARCHAR(255),
    FOREIGN KEY (book_authors_BookID) REFERENCES tbl_book(book_BookID) ON DELETE CASCADE
);

-- Create Library Branch Table
CREATE TABLE tbl_library_branch (
    library_branch_BranchID INT AUTO_INCREMENT PRIMARY KEY,
    library_branch_BranchName VARCHAR(255),
    library_branch_BranchAddress TEXT
);

-- Create Book Copies Table (with foreign keys to Book and Branch)
CREATE TABLE tbl_book_copies (
    book_copies_CopiesID INT AUTO_INCREMENT PRIMARY KEY,
    book_copies_BookID INT,
    book_copies_BranchID INT,
    book_copies_No_Of_Copies INT,
    FOREIGN KEY (book_copies_BookID) REFERENCES tbl_book(book_BookID) ON DELETE CASCADE,
    FOREIGN KEY (book_copies_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID) ON DELETE CASCADE
);

-- Create Borrower Table
CREATE TABLE tbl_borrower (
    borrower_CardNo INT AUTO_INCREMENT PRIMARY KEY,
    borrower_BorrowerName VARCHAR(255),
    borrower_BorrowerAddress TEXT,
    borrower_BorrowerPhone VARCHAR(20)
);

-- Create Book Loans Table (with foreign keys to Book, Branch, and Borrower)
CREATE TABLE tbl_book_loans (
    book_loans_LoansID INT AUTO_INCREMENT PRIMARY KEY,
    book_loans_BookID INT,
    book_loans_BranchID INT,
    book_loans_CardNo INT,
    book_loans_DateOut Varchar(255),
    book_loans_DueDate DATE,
    FOREIGN KEY (book_loans_BookID) REFERENCES tbl_book(book_BookID) ON DELETE CASCADE,
    FOREIGN KEY (book_loans_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID) ON DELETE CASCADE,
    FOREIGN KEY (book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo) ON DELETE CASCADE
);


-- Select all data after tables are created
SELECT * FROM tbl_publisher;
SELECT * FROM tbl_book;
SELECT * FROM tbl_book_authors;
SELECT * FROM tbl_borrower;
SELECT * FROM tbl_library_branch;
SELECT * FROM tbl_book_copies;
select*from tbl_book_loans;


  #1 How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"

select  l.library_branch_BranchName,bc.book_copies_No_Of_Copies from tbl_book_copies bc
join tbl_book b on  bc.book_copies_BookID = b.book_BookID
join tbl_library_branch l on  bc.book_copies_BranchID=l.library_branch_BranchID
where b.book_Title = 'The Lost Tribe'
and l.library_branch_BranchName = 'Sharpstown';

#2 How many copies of the book titled "The Lost Tribe" are owned by each library branch?
select  l.library_branch_BranchName,sum(bc.book_copies_No_Of_Copies) as total_copies from tbl_book_copies bc
join tbl_book b on  bc.book_copies_BookID = b.book_BookID
join tbl_library_branch l on  bc.book_copies_BranchID=l.library_branch_BranchID
where b.book_Title = 'The Lost Tribe'
group by l.library_branch_BranchName;

#3Retrieve the names of all borrowers who do not have any books checked out.

select b.borrower_BorrowerName from tbl_borrower b
left join tbl_book_loans t on b.borrower_CardNo=t.book_loans_CardNo
where t.book_loans_CardNo is null;

#4 For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 


SELECT b.book_Title, br.borrower_BorrowerName, br.borrower_BorrowerAddress
FROM tbl_book_loans l
JOIN tbl_book b ON l.book_loans_BookID = b.book_BookID
JOIN tbl_library_branch lb ON l.book_loans_BranchID = lb.library_branch_BranchID
JOIN tbl_borrower br ON br.borrower_CardNo = l.book_loans_CardNo
WHERE lb.library_branch_BranchName = 'Sharpstown'
AND l.book_loans_DueDate = '2/3/18';

#5 For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

select l.library_branch_BranchName,count(b.book_loans_BookID) as books_loan_out from tbl_library_branch l
join  tbl_book_loans b on l.library_branch_BranchID=b.book_loans_BranchID
GROUP BY l.library_branch_BranchName;

#6 Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.

select br.borrower_borrowername, br.borrower_borroweraddress, count(bl.book_loans_bookid) as books_checked_out
from tbl_borrower br
join tbl_book_loans bl on br.borrower_cardno = bl.book_loans_cardno
group by br.borrower_cardno
having books_checked_out > 5;

#7 For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".

select b.book_title, sum(bc.book_copies_no_of_copies) as total_copies from tbl_book b
join tbl_book_authors ba on b.book_bookid = ba.book_authors_bookid
join tbl_book_copies bc on b.book_bookid = bc.book_copies_bookid
join tbl_library_branch lb on bc.book_copies_branchid = lb.library_branch_branchid
where ba.book_authors_authorname = 'stephen king' 
and lb.library_branch_branchname = 'central'
group by b.book_title;








SELECT * FROM tbl_borrower;


















  
  
   




