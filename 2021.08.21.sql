-- 마당서점의 고객이 요구하는 다음 질문에 대해 SQL문을 작성하시오.
-- (1) 도서번호가 1인 도서의 이름
use madang;

select *
from book
where bookid = 1
;

-- (2) 가격이 20,000원 이상인 도서의 이름
select *
from book
where price >= 20000;

-- (3) 박지성의 총 구매액
SELECT 
    SUM(saleprice)
FROM
    customer AS C
        LEFT JOIN
    orders AS O ON C.custid = O.custid
WHERE
    C.name = '박지성';

-- duplicate column 어떻게 했더라.. ㅎ.ㅎ....?

SELECT 
    SUM(saleprice)
FROM
    (SELECT 
        *
    FROM
        customer AS C
    LEFT JOIN orders AS O ON C.custid = O.custid) AS A
WHERE
    A.name = '박지성';

-- (4) 박지성이 구매한 도서의 수
SELECT COUNT(bookid)
FROM customer as C
LEFT JOIN orders as O
ON C.custid = O.custid
WHERE C.name = '박지성'
;


-- (5) 박지성이 구매한 도서의 출판사 수
SELECT C.custid, O.orderid, O.bookid, O.saleprice, C.name
FROM customer as C
LEFT JOIN orders as O
ON C.custid = O.custid
;

SELECT *
FROM book as B
RIGHT JOIN (SELECT C.custid, O.orderid, O.bookid, O.saleprice,  C.name
FROM customer as C
LEFT JOIN orders as O
ON C.custid = O.custid) AS A
ON A.bookid = A.bookid
-- HERE A.name = '박지성'
; -- 이거 왜이래..?


-- (6) 박지성이 구매한 도서의 이름, 가격, 정가와 판매가격의 차이
-- 세개 조인하는 거 연습하기
SELECT B.bookname, O.saleprice, B.price - O.saleprice
FROM orders as O, customer as C, book as B
WHERE C.custid = O.custid AND B.bookid = O.bookid AND C.name = '박지성'
;

-- (8) 박지성이 구매하지 않은 도서의 이름
SELECT B.bookname
FROM orders as O, book as B, customer as C
WHERE C.custid = O.custid AND B.bookid = O.bookid AND B.bookid = O.bookid AND C.name != '박지성'
;



-- 2.
-- (1) 마당서점 도서의 총 개수
SELECT COUNT(bookname)
FROM book;
;

SELECT *
FROM book;

-- (2) 마당서점에 도서를 출고하는 출판사의 총 개수
SELECT COUNT(publisher)
FROM book;

-- (3) 모든 고객의 이름, 주소
SELECT name, address
FROM customer;

-- (4) 2014년 7월 4일 ~ 7궝 7깅 사이에 주문받은 도서의 주문번호
SELECT *
FROM orders
WHERE orderdate BETWEEN '20140704' AND '20170707'
;

-- (5) 그 사이에 주문받은 도서를 제외한 도서의 주문번호
SELECT *
FROM orders
WHERE orderdate NOT BETWEEN '2010704' AND '20140707';

-- (6) 성이 '김'씨인 고객의 이름과 주소
SELECT name, address
FROM customer
WHERE name LIKE '김%';

-- (7) 성이 '김'씨이고 이름이 '아'로 끝나는 고객의 이름과 주소
SELECT *
FROM customer
WHERE name LIKE '김%아';

-- (8) 주문하지 않은 고객의 이름 (부속질의 사용)
SELECT *
FROM orders as O, customer as C
WHERE O.custid = C.custid;

SELECT *
FROM customer
WHERE name NOT IN (
SELECT name
FROM orders as O, customer as C
WHERE O.custid = C.custid);

-- (9) 주문 금액의 총액과 주문의 평균 금액
SELECT SUM(saleprice), AVG(saleprice)
FROM orders;

-- (10) 고객의 이름과 고개별 구매액
SELECT C.name, SUM(O.saleprice)
FROM orders as O, customer as C
WHERE O.custid = C.custid
GROUP BY C.name
;

-- (11) 고객의 이름과 고객이 구매한 도서 목록
SELECT C.name, B.bookname
FROM customer as C, orders as O, book as B
WHERE C.custid = O.custid AND B.bookid = O.bookid
ORDER BY C.name
;

-- (12) 도서의 가격(Book 테이블)과 판매가격(Orders 테이블)의 차이가 가장 많은 주문
SELECT MAX(B.price - O.saleprice)
FROM orders as O, book as B
WHERE B.bookid = O.bookid
;

-- (13) 도서의 판매액 평균보다 자신의 구매액 평균이 더 높은 고객의 이름
SELECT name, AVG(O.saleprice)
FROM orders as O, customer as C
WHERE O.custid = C.custid
GROUP BY C.name
HAVING AVG(saleprice) > (SELECT AVG(saleprice) FROM orders);
;


-- 3. 마당서점에서 다음의 심화된 질문에 대해 SQL문을 작성하시오.
-- (1) 박지성이 구매한 도서의 출판사와 같은 출판사에서 도서를 구매한 고객의 이름
SELECT C.name
FROM customer as C, orders as O, book as B
WHERE C.custid = O.custid AND B.bookid = O.bookid AND B.publisher = (SELECT publisher
FROM book as B, customer as C, orders as O
WHERE C.custid = O.custid AND B.bookid = O.bookid AND C.name = '박지성')
;

SELECT publisher
FROM book as B, customer as C, orders as O
WHERE C.custid = O.custid AND B.bookid = O.bookid AND C.name = '박지성'
;

SELECT *
FROM customer;

-- (2) 두 개 이상의 서로 다른 출판사에서 도서를 구매한 고객의 이름
SELECT C.name, COUNT(DISTINCT B.publisher)
FROM book as B, orders as O, customer as C
WHERE B.bookid = O.bookid AND C.custid = O.custid
GROUP BY C.name
;

SELECT *
FROM (SELECT C.name, COUNT(DISTINCT B.publisher) AS count
FROM book as B, orders as O, customer as C
WHERE B.bookid = O.bookid AND C.custid = O.custid
GROUP BY C.name) AS A
WHERE count >=2;

-- (3) 전체 고객의 30% 이상이 구매한 도서
SELECT B.bookname, COUNT(DISTINCT C.name) AS cnt
FROM customer as C, book as B, orders AS O
WHERE C.custid = O.custid AND B.bookid = O.bookid
GROUP BY B.bookname
;

SELECT *
FROM customer AS A
LEFT JOIN (SELECT B.bookname, COUNT(DISTINCT C.name) AS cnt
FROM customer as C, book as B, orders AS O
WHERE C.custid = O.custid AND B.bookid = O.bookid
GROUP BY B.bookname) AS B
WHERE (cnt >= 0.3*(COUNT(DISTINCT A.name))
;


SELECT *
FROM (SELECT C.name, B.bookname
FROM customer as C, book as B, orders AS O
WHERE C.custid = O.custid AND B.bookid = O.bookid) AS A
WHERE 
;






