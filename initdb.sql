
-- Дамп структуры для таблица egais1.alcformab
CREATE TABLE IF NOT EXISTS `alcformab` (
  `nummark` int(3) NOT NULL,
  `partmark` int(12) NOT NULL,
  `formA` varchar(32) COLLATE utf8_bin NOT NULL,
  `formB` varchar(32) COLLATE utf8_bin NOT NULL,
  `oldformb` varchar(32) COLLATE utf8_bin NOT NULL,
  `alcitem` varchar(20) COLLATE utf8_bin NOT NULL,
  `minnummark` int(20) NOT NULL,
  `maxnummark` int(20) NOT NULL,
  `AlcRegId` varchar(20) COLLATE utf8_bin NOT NULL,
  `marknum` varchar(3) COLLATE utf8_bin NOT NULL,
  `crdate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.const
CREATE TABLE IF NOT EXISTS `const` (
  `name` varchar(20) COLLATE utf8_bin NOT NULL,
  `value` varchar(128) COLLATE utf8_bin NOT NULL,
  `storepoint` varchar(32) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.d5structure
CREATE TABLE IF NOT EXISTS `d5structure` (
  `uuid` varchar(48) COLLATE utf8_bin NOT NULL,
  `typename` varchar(20) COLLATE utf8_bin NOT NULL,
  `tablename` varchar(20) COLLATE utf8_bin NOT NULL,
  `statname` varchar(20) COLLATE utf8_bin NOT NULL,
  `printname` varchar(48) COLLATE utf8_bin NOT NULL,
  `caption` varchar(48) COLLATE utf8_bin NOT NULL,
  `colcount` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.discountcards
CREATE TABLE IF NOT EXISTS `discountcards` (
  `card` varchar(20) COLLATE utf8_bin NOT NULL,
  `crdate` date NOT NULL,
  `discount` varchar(20) COLLATE utf8_bin NOT NULL,
  `name` varchar(20) COLLATE utf8_bin NOT NULL,
  `contacts` varchar(120) COLLATE utf8_bin NOT NULL,
  `isdelete` varchar(1) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.doc21
CREATE TABLE IF NOT EXISTS `doc21` (
  `numdoc` varchar(12) COLLATE utf8_bin NOT NULL,
  `datedoc` varchar(10) COLLATE utf8_bin NOT NULL,
  `AlcItem` varchar(20) COLLATE utf8_bin NOT NULL,
  `EAN13` varchar(13) COLLATE utf8_bin NOT NULL,
  `partplomb` varchar(3) COLLATE utf8_bin NOT NULL,
  `numplomb` varchar(20) COLLATE utf8_bin NOT NULL,
  `valuetov` int(15) NOT NULL,
  `price` float NOT NULL,
  `forma` varchar(32) COLLATE utf8_bin NOT NULL,
  `formb` varchar(32) COLLATE utf8_bin NOT NULL,
  `crdate` date NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL,
  `posit` int(4) NOT NULL,
  `factcount` int(15) NOT NULL,
  `nowformb` varchar(20) COLLATE utf8_bin NOT NULL,
  `tovar` varchar(200) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.doc211
CREATE TABLE IF NOT EXISTS `doc211` (
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedoc` varchar(10) COLLATE utf8_bin NOT NULL,
  `numposit` int(5) NOT NULL,
  `tovar` varchar(200) COLLATE utf8_bin NOT NULL,
  `listean13` varchar(64) COLLATE utf8_bin NOT NULL,
  `alcitem` varchar(20) COLLATE utf8_bin NOT NULL,
  `formA` varchar(32) COLLATE utf8_bin NOT NULL,
  `formB` varchar(32) COLLATE utf8_bin NOT NULL,
  `Count` float NOT NULL,
  `Price` float NOT NULL,
  `ClientRegId` varchar(20) COLLATE utf8_bin NOT NULL,
  `ClientName` varchar(120) COLLATE utf8_bin NOT NULL,
  `import` int(1) NOT NULL,
  `crdate` date NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.doc221
CREATE TABLE IF NOT EXISTS `doc221` (
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `docid` varchar(64) COLLATE utf8_bin NOT NULL,
  `datedoc` varchar(10) COLLATE utf8_bin NOT NULL,
  `numposit` varchar(20) COLLATE utf8_bin NOT NULL,
  `tovar` varchar(200) COLLATE utf8_bin NOT NULL,
  `listean13` varchar(64) COLLATE utf8_bin NOT NULL,
  `alcitem` varchar(20) COLLATE utf8_bin NOT NULL,
  `formA` varchar(32) COLLATE utf8_bin NOT NULL,
  `formB` varchar(32) COLLATE utf8_bin NOT NULL,
  `Count` float NOT NULL,
  `factCount` float NOT NULL,
  `Price` float NOT NULL,
  `ClientRegId` varchar(20) COLLATE utf8_bin NOT NULL,
  `ClientName` varchar(120) COLLATE utf8_bin NOT NULL,
  `import` int(1) NOT NULL,
  `storepoint` varchar(32) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.doc221fix
CREATE TABLE IF NOT EXISTS `doc221fix` (
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `packet` varchar(120) COLLATE utf8_bin NOT NULL,
  `fixmark` varchar(150) COLLATE utf8_bin NOT NULL,
  `docid` varchar(64) COLLATE utf8_bin NOT NULL,
  `alccode` varchar(38) COLLATE utf8_bin NOT NULL,
  `forma` varchar(20) COLLATE utf8_bin NOT NULL,
  `formb` varchar(20) COLLATE utf8_bin NOT NULL,
  `accept` varchar(1) COLLATE utf8_bin NOT NULL,
  `idposition` varchar(20) COLLATE utf8_bin NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.doc23
CREATE TABLE IF NOT EXISTS `doc23` (
  `docid` varchar(48) COLLATE utf8_bin NOT NULL,
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `alccode` varchar(20) COLLATE utf8_bin NOT NULL,
  `markplomb` varchar(200) COLLATE utf8_bin NOT NULL,
  `forma` varchar(32) COLLATE utf8_bin NOT NULL,
  `formb` varchar(32) COLLATE utf8_bin NOT NULL,
  `count` int(10) NOT NULL,
  `numfix` varchar(20) COLLATE utf8_bin NOT NULL,
  `datefix` date NOT NULL,
  `import` varchar(1) COLLATE utf8_bin NOT NULL,
  `crdate` date NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.doc24
CREATE TABLE IF NOT EXISTS `doc24` (
  `docid` varchar(48) COLLATE utf8_bin NOT NULL,
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `tovar` varchar(512) COLLATE utf8_bin NOT NULL,
  `alccode` varchar(20) COLLATE utf8_bin NOT NULL,
  `price` float NOT NULL,
  `forma` varchar(32) COLLATE utf8_bin NOT NULL,
  `formb` varchar(32) COLLATE utf8_bin NOT NULL,
  `count` int(10) NOT NULL,
  `numposit` int(10) NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.doc25
CREATE TABLE IF NOT EXISTS `doc25` (
  `docid` varchar(48) COLLATE utf8_bin NOT NULL,
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `alccode` varchar(20) COLLATE utf8_bin NOT NULL,
  `pdf417` varchar(70) COLLATE utf8_bin NOT NULL,
  `forma` varchar(32) COLLATE utf8_bin NOT NULL,
  `formb` varchar(32) COLLATE utf8_bin NOT NULL,
  `numfix` varchar(20) COLLATE utf8_bin NOT NULL,
  `datefix` date NOT NULL,
  `import` varchar(1) COLLATE utf8_bin NOT NULL,
  `crdate` date NOT NULL,
  `count` int(20) NOT NULL,
  `restcount` int(20) NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.doc26
CREATE TABLE IF NOT EXISTS `doc26` (
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `count` int(10) NOT NULL,
  `alccode` varchar(20) COLLATE utf8_bin NOT NULL,
  `crdate` date NOT NULL,
  `restcount` int(10) NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.doc27
CREATE TABLE IF NOT EXISTS `doc27` (
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `count` int(10) NOT NULL,
  `alccode` varchar(20) COLLATE utf8_bin NOT NULL,
  `form2` varchar(20) COLLATE utf8_bin NOT NULL,
  `crdate` date NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.doc28
CREATE TABLE IF NOT EXISTS `doc28` (
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `count` int(10) NOT NULL,
  `alccode` varchar(20) COLLATE utf8_bin NOT NULL,
  `price` float NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.doc28fix
CREATE TABLE IF NOT EXISTS `doc28fix` (
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `packet` varchar(120) COLLATE utf8_bin NOT NULL,
  `fixmark` varchar(150) COLLATE utf8_bin NOT NULL,
  `docid` varchar(64) COLLATE utf8_bin NOT NULL,
  `alccode` varchar(38) COLLATE utf8_bin NOT NULL,
  `forma` varchar(20) COLLATE utf8_bin NOT NULL,
  `formb` varchar(20) COLLATE utf8_bin NOT NULL,
  `accept` varchar(1) COLLATE utf8_bin NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.doc29
CREATE TABLE IF NOT EXISTS `doc29` (
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `count` int(10) NOT NULL,
  `alccode` varchar(20) COLLATE utf8_bin NOT NULL,
  `countfact` int(10) NOT NULL,
  `countdelta` int(10) NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.doc30
CREATE TABLE IF NOT EXISTS `doc30` (
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `marktype` varchar(3) COLLATE utf8_bin NOT NULL,
  `markserial` varchar(3) COLLATE utf8_bin NOT NULL,
  `marknumber` varchar(20) COLLATE utf8_bin NOT NULL,
  `pdf417` varchar(68) COLLATE utf8_bin NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.doc31
CREATE TABLE IF NOT EXISTS `doc31` (
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `quality` int(10) NOT NULL,
  `alccode` varchar(20) COLLATE utf8_bin NOT NULL,
  `form1` varchar(20) COLLATE utf8_bin NOT NULL,
  `form2` varchar(20) COLLATE utf8_bin NOT NULL,
  `crdate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.doccash
CREATE TABLE IF NOT EXISTS `doccash` (
  `numdoc` varchar(12) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `numkass` int(12) NOT NULL,
  `namesection` varchar(64) COLLATE utf8_bin NOT NULL,
  `numsection` varchar(12) COLLATE utf8_bin NOT NULL,
  `numhw` varchar(20) COLLATE utf8_bin NOT NULL,
  `numtrans` int(12) NOT NULL,
  `datetrans` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `numcheck` int(12) NOT NULL,
  `kassir` int(12) NOT NULL,
  `typetrans` int(3) NOT NULL,
  `plu` int(12) NOT NULL,
  `name` varchar(64) COLLATE utf8_bin NOT NULL,
  `eanbc` varchar(13) COLLATE utf8_bin NOT NULL,
  `fullname` varchar(512) COLLATE utf8_bin NOT NULL,
  `price` float NOT NULL,
  `quantity` float NOT NULL,
  `summ` float NOT NULL,
  `banking` char(1) COLLATE utf8_bin NOT NULL,
  `urlegais` varchar(255) COLLATE utf8_bin NOT NULL,
  `alccode` varchar(64) COLLATE utf8_bin NOT NULL,
  `regfr` char(1) COLLATE utf8_bin NOT NULL,
  `idtable` int(12) NOT NULL,
  `closecheck` char(1) COLLATE utf8_bin NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL,
  `noclosecheck` char(1) COLLATE utf8_bin NOT NULL,
  `regegais` char(1) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.docformab
CREATE TABLE IF NOT EXISTS `docformab` (
  `docid` varchar(64) COLLATE utf8_bin NOT NULL,
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `numPosition` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `Forma` varchar(32) COLLATE utf8_bin NOT NULL,
  `formb` varchar(32) COLLATE utf8_bin NOT NULL,
  `OldFormB` varchar(32) COLLATE utf8_bin NOT NULL,
  `periodmark` varchar(256) COLLATE utf8_bin NOT NULL,
  `AlcItem` varchar(20) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.docjurnale
CREATE TABLE IF NOT EXISTS `docjurnale` (
  `NumDoc` varchar(32) COLLATE utf8_bin NOT NULL,
  `Summa` float NOT NULL,
  `sign` varchar(128) COLLATE utf8_bin NOT NULL,
  `RegId` varchar(16) COLLATE utf8_bin NOT NULL,
  `WBRegId` varchar(24) COLLATE utf8_bin NOT NULL,
  `DocBase` varchar(14) COLLATE utf8_bin NOT NULL,
  `ClientRegId` varchar(20) COLLATE utf8_bin NOT NULL,
  `ClientName` varchar(120) COLLATE utf8_bin NOT NULL,
  `EGAISFixNumber` varchar(20) COLLATE utf8_bin NOT NULL,
  `EGAISFixDate` date NOT NULL,
  `uid` varchar(42) COLLATE utf8_bin NOT NULL,
  `Type` varchar(20) COLLATE utf8_bin NOT NULL,
  `registry` varchar(1) COLLATE utf8_bin NOT NULL,
  `status` varchar(3) COLLATE utf8_bin NOT NULL,
  `comment` varchar(512) COLLATE utf8_bin NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL,
  `block` varchar(1) COLLATE utf8_bin NOT NULL,
  `datestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `DocId` varchar(64) COLLATE utf8_bin NOT NULL,
  `addressclient` varchar(512) COLLATE utf8_bin NOT NULL,
  `ClientAddress` varchar(512) COLLATE utf8_bin NOT NULL,
  `dateDoc` date NOT NULL,
  `isDelete` varchar(1) COLLATE utf8_bin NOT NULL,
  `torgpoint` varchar(20) COLLATE utf8_bin NOT NULL,
  `ClientAccept` varchar(1) COLLATE utf8_bin NOT NULL,
  `issueclient` varchar(1) COLLATE utf8_bin NOT NULL,
  `utmv2` varchar(1) COLLATE utf8_bin NOT NULL,
  `repealwb` varchar(1) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.doctransp
CREATE TABLE IF NOT EXISTS `doctransp` (
  `numdoc` varchar(48) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `egaisid` varchar(48) COLLATE utf8_bin NOT NULL,
  `CAR` varchar(48) COLLATE utf8_bin NOT NULL,
  `CUSTOMER` varchar(48) COLLATE utf8_bin NOT NULL,
  `DRIVER` varchar(48) COLLATE utf8_bin NOT NULL,
  `LOADPOINT` varchar(512) COLLATE utf8_bin NOT NULL,
  `UNLOADPOINT` varchar(512) COLLATE utf8_bin NOT NULL,
  `FORWARDER` varchar(48) COLLATE utf8_bin NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.docx21
CREATE TABLE IF NOT EXISTS `docx21` (
  `docid` varchar(48) COLLATE utf8_bin NOT NULL,
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `Accepted` varchar(1) COLLATE utf8_bin NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.docx23
CREATE TABLE IF NOT EXISTS `docx23` (
  `docid` varchar(48) COLLATE utf8_bin NOT NULL,
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `status` varchar(1) COLLATE utf8_bin NOT NULL,
  `statusname` varchar(512) COLLATE utf8_bin NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.docx24
CREATE TABLE IF NOT EXISTS `docx24` (
  `docid` varchar(48) COLLATE utf8_bin NOT NULL,
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `basedatedoc` date NOT NULL,
  `basenumdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `Accepted` varchar(1) COLLATE utf8_bin NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.docx26
CREATE TABLE IF NOT EXISTS `docx26` (
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `clientprovider` varchar(20) COLLATE utf8_bin NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.docx27
CREATE TABLE IF NOT EXISTS `docx27` (
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `ownernumdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `ownerdatedoc` date NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.docx28
CREATE TABLE IF NOT EXISTS `docx28` (
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `notedoc` varchar(512) COLLATE utf8_bin NOT NULL,
  `typedoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.docx29
CREATE TABLE IF NOT EXISTS `docx29` (
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `numdocChargeOn` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedocChargeOn` date NOT NULL,
  `numdocWriteOff` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedocWriteOff` date NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.docx31
CREATE TABLE IF NOT EXISTS `docx31` (
  `numdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `ownernumdoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `ownerdatedoc` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.egaisfiles
CREATE TABLE IF NOT EXISTS `egaisfiles` (
  `url` varchar(255) COLLATE utf8_bin NOT NULL,
  `xmlfile` mediumtext COLLATE utf8_bin NOT NULL,
  `DATESTAMP` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `typefile` varchar(48) COLLATE utf8_bin NOT NULL,
  `replyId` varchar(64) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.numberdoc
CREATE TABLE IF NOT EXISTS `numberdoc` (
  `TypeDoc` varchar(64) COLLATE utf8_bin NOT NULL,
  `Number` int(128) NOT NULL,
  `Prefix` varchar(32) COLLATE utf8_bin NOT NULL,
  `storepoint` varchar(32) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.regformb
CREATE TABLE IF NOT EXISTS `regformb` (
  `WBRegId` varchar(48) COLLATE utf8_bin NOT NULL,
  `uid` varchar(64) COLLATE utf8_bin NOT NULL,
  `posit` int(15) NOT NULL,
  `datefix` date NOT NULL,
  `numttn` varchar(48) COLLATE utf8_bin NOT NULL,
  `comment` varchar(250) COLLATE utf8_bin NOT NULL,
  `quantity` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.regreservshop
CREATE TABLE IF NOT EXISTS `regreservshop` (
  `alcname` varchar(512) COLLATE utf8_bin NOT NULL,
  `alccode` varchar(20) COLLATE utf8_bin NOT NULL,
  `Quantity` int(10) NOT NULL,
  `daterests` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.regrestsproduct
CREATE TABLE IF NOT EXISTS `regrestsproduct` (
  `Quantity` int(15) NOT NULL,
  `InformARegId` varchar(32) COLLATE utf8_bin NOT NULL,
  `InformBRegId` varchar(32) COLLATE utf8_bin NOT NULL,
  `AlcCode` varchar(20) COLLATE utf8_bin NOT NULL,
  `AlcName` varchar(256) COLLATE utf8_bin NOT NULL,
  `dateTTN` varchar(10) COLLATE utf8_bin NOT NULL,
  `numTTN` varchar(32) COLLATE utf8_bin NOT NULL,
  `storepoint` varchar(20) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.regrestsshop
CREATE TABLE IF NOT EXISTS `regrestsshop` (
  `alcname` varchar(512) COLLATE utf8_bin NOT NULL,
  `alccode` varchar(20) COLLATE utf8_bin NOT NULL,
  `Quantity` int(10) NOT NULL,
  `daterests` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.regshoptable
CREATE TABLE IF NOT EXISTS `regshoptable` (
  `datedoc` date NOT NULL,
  `numkass` int(12) NOT NULL,
  `namesection` varchar(64) COLLATE utf8_bin NOT NULL,
  `numsection` varchar(12) COLLATE utf8_bin NOT NULL,
  `numtrans` int(12) NOT NULL,
  `numcheck` int(12) NOT NULL,
  `plu` int(12) NOT NULL,
  `name` varchar(64) COLLATE utf8_bin NOT NULL,
  `eanbc` varchar(13) COLLATE utf8_bin NOT NULL,
  `fullname` varchar(512) COLLATE utf8_bin NOT NULL,
  `price` float NOT NULL,
  `quantity` float NOT NULL,
  `summ` float NOT NULL,
  `urlegais` varchar(255) COLLATE utf8_bin NOT NULL,
  `alccode` varchar(64) COLLATE utf8_bin NOT NULL,
  `idtable` int(12) NOT NULL,
  `storepoint` varchar(32) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.replyid
CREATE TABLE IF NOT EXISTS `replyid` (
  `numdoc` varchar(48) COLLATE utf8_bin NOT NULL,
  `datedoc` date NOT NULL,
  `egaisid` varchar(48) COLLATE utf8_bin NOT NULL,
  `storepoint` varchar(32) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.spformfix
CREATE TABLE IF NOT EXISTS `spformfix` (
  `numfix` varchar(20) COLLATE utf8_bin NOT NULL,
  `datefix` date NOT NULL,
  `AlcItem` varchar(20) COLLATE utf8_bin NOT NULL,
  `formA` varchar(32) COLLATE utf8_bin NOT NULL,
  `crdate` varchar(10) COLLATE utf8_bin NOT NULL,
  `nummark` varchar(3096) COLLATE utf8_bin NOT NULL,
  `ttndate` date NOT NULL,
  `ttnnumber` varchar(32) COLLATE utf8_bin NOT NULL,
  `shipper` varchar(32) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.splicproducer
CREATE TABLE IF NOT EXISTS `splicproducer` (
  `imns` varchar(5) COLLATE utf8_bin NOT NULL,
  `ClientRegId` varchar(20) COLLATE utf8_bin NOT NULL,
  `fullname` varchar(128) COLLATE utf8_bin NOT NULL,
  `startdatelic` date NOT NULL,
  `enddatelic` date NOT NULL,
  `serlic` varchar(64) COLLATE utf8_bin NOT NULL,
  `numlic` varchar(64) COLLATE utf8_bin NOT NULL,
  `deplic` varchar(255) COLLATE utf8_bin NOT NULL,
  `Active` int(1) NOT NULL,
  `TypeProducer` varchar(8) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.spproducer
CREATE TABLE IF NOT EXISTS `spproducer` (
  `ClientRegId` varchar(20) COLLATE utf8_bin NOT NULL,
  `FullName` varchar(120) COLLATE utf8_bin NOT NULL,
  `inn` varchar(12) COLLATE utf8_bin NOT NULL,
  `kpp` varchar(9) COLLATE utf8_bin NOT NULL,
  `ShortName` varchar(50) COLLATE utf8_bin NOT NULL,
  `description` varchar(266) COLLATE utf8_bin NOT NULL,
  `region` varchar(3) COLLATE utf8_bin NOT NULL,
  `Country` varchar(3) COLLATE utf8_bin NOT NULL,
  `Active` int(1) NOT NULL,
  `type1producer` varchar(2) COLLATE utf8_bin NOT NULL,
  `typeproducer` varchar(8) COLLATE utf8_bin NOT NULL,
  `liter` varchar(512) COLLATE utf8_bin NOT NULL,
  `sity` varchar(64) COLLATE utf8_bin NOT NULL,
  `area` varchar(64) COLLATE utf8_bin NOT NULL,
  `locality` varchar(64) COLLATE utf8_bin NOT NULL,
  `street` varchar(64) COLLATE utf8_bin NOT NULL,
  `home` varchar(5) COLLATE utf8_bin NOT NULL,
  `homecorpus` varchar(5) COLLATE utf8_bin NOT NULL,
  `room` varchar(5) COLLATE utf8_bin NOT NULL,
  `indexregion` varchar(8) COLLATE utf8_bin NOT NULL,
  `addressimns` varchar(512) COLLATE utf8_bin NOT NULL,
  `utmv2` varchar(1) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.spproduct
CREATE TABLE IF NOT EXISTS `spproduct` (
  `AlcCode` varchar(20) COLLATE utf8_bin NOT NULL,
  `egaisname` varchar(512) COLLATE utf8_bin NOT NULL,
  `name` varchar(512) COLLATE utf8_bin NOT NULL,
  `Import` varchar(1) COLLATE utf8_bin NOT NULL,
  `Capacity` varchar(10) COLLATE utf8_bin NOT NULL,
  `AlcVolume` varchar(10) COLLATE utf8_bin NOT NULL,
  `ProductVCode` varchar(3) COLLATE utf8_bin NOT NULL,
  `ClientRegId` varchar(20) COLLATE utf8_bin NOT NULL,
  `IClientRegId` varchar(20) COLLATE utf8_bin NOT NULL,
  `listbarcode` varchar(512) COLLATE utf8_bin NOT NULL,
  `unpacked` varchar(1) COLLATE utf8_bin NOT NULL,
  `typeproducer` varchar(2) COLLATE utf8_bin NOT NULL,
  `pluid` int(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.sprfastgood
CREATE TABLE IF NOT EXISTS `sprfastgood` (
  `id` varchar(1) COLLATE utf8_bin NOT NULL,
  `name` varchar(64) COLLATE utf8_bin NOT NULL,
  `plu` varchar(254) COLLATE utf8_bin NOT NULL,
  `price` float NOT NULL,
  `alcgoods` varchar(1) COLLATE utf8_bin NOT NULL,
  `updating` varchar(1) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.sprgoods
CREATE TABLE IF NOT EXISTS `sprgoods` (
  `plu` int(12) NOT NULL,
  `name` varchar(64) COLLATE utf8_bin NOT NULL,
  `fullname` varchar(254) COLLATE utf8_bin NOT NULL,
  `weightgood` varchar(1) COLLATE utf8_bin NOT NULL,
  `alcgoods` varchar(1) COLLATE utf8_bin NOT NULL,
  `barcodes` varchar(512) COLLATE utf8_bin NOT NULL,
  `currentprice` float NOT NULL,
  `updating` varchar(1) COLLATE utf8_bin NOT NULL,
  `extcode` varchar(48) COLLATE utf8_bin NOT NULL,
  `article` varchar(48) COLLATE utf8_bin NOT NULL,
  `groupid` varchar(48) COLLATE utf8_bin NOT NULL,
  `section` varchar(2) COLLATE utf8_bin NOT NULL,
  `viewcash` varchar(1) COLLATE utf8_bin NOT NULL,
  `isdelete` varchar(1) COLLATE utf8_bin NOT NULL,
  `freeprice` varchar(1) COLLATE utf8_bin NOT NULL,
  `notkkm` varchar(1) COLLATE utf8_bin NOT NULL,
  `typegood` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.sprgroups
CREATE TABLE IF NOT EXISTS `sprgroups` (
  `groupid` varchar(48) COLLATE utf8_bin NOT NULL,
  `name` varchar(64) COLLATE utf8_bin NOT NULL,
  `fullname` varchar(254) COLLATE utf8_bin NOT NULL,
  `viewcash` varchar(1) COLLATE utf8_bin NOT NULL,
  `alcgoods` varchar(1) COLLATE utf8_bin NOT NULL,
  `updating` varchar(1) COLLATE utf8_bin NOT NULL,
  `ownergroupid` varchar(48) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.sprhalls
CREATE TABLE IF NOT EXISTS `sprhalls` (
  `id` int(12) NOT NULL,
  `name` varchar(64) COLLATE utf8_bin NOT NULL,
  `active` varchar(1) COLLATE utf8_bin NOT NULL,
  `numkass` varchar(12) COLLATE utf8_bin NOT NULL,
  `color` int(12) NOT NULL,
  `alcgoods` varchar(1) COLLATE utf8_bin NOT NULL,
  `updating` varchar(1) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.sprkass
CREATE TABLE IF NOT EXISTS `sprkass` (
  `numkass` int(12) NOT NULL,
  `lastupdate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `namekass` varchar(32) COLLATE utf8_bin NOT NULL,
  `alckass` varchar(1) COLLATE utf8_bin NOT NULL,
  `banking` varchar(1) COLLATE utf8_bin NOT NULL,
  `kassirname` varchar(64) COLLATE utf8_bin NOT NULL,
  `numhw` varchar(22) COLLATE utf8_bin NOT NULL,
  `multisection` varchar(1) COLLATE utf8_bin NOT NULL,
  `master` varchar(1) COLLATE utf8_bin NOT NULL,
  `ofd` varchar(1) COLLATE utf8_bin NOT NULL,
  `typekkt` varchar(3) COLLATE utf8_bin NOT NULL,
  `modelkkt` varchar(7) COLLATE utf8_bin NOT NULL,
  `numsection` varchar(1) COLLATE utf8_bin NOT NULL,
  `fnnumber` varchar(20) COLLATE utf8_bin NOT NULL,
  `nalogrn` varchar(20) COLLATE utf8_bin NOT NULL,
  `taxtype` varchar(2) COLLATE utf8_bin NOT NULL,
  `devtype` int(4) NOT NULL,
  `deviceipport` int(5) NOT NULL,
  `deviceiphost` varchar(64) COLLATE utf8_bin NOT NULL,
  `devicehwbaud` int(5) NOT NULL,
  `devicehwport` varchar(64) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.sprscale
CREATE TABLE IF NOT EXISTS `sprscale` (
  `id` int(12) NOT NULL,
  `namescale` varchar(32) COLLATE utf8_bin NOT NULL,
  `lastupdate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `localconnect` varchar(1) COLLATE utf8_bin NOT NULL,
  `cashconnect` varchar(1) COLLATE utf8_bin NOT NULL,
  `cash_id` int(12) NOT NULL,
  `devtype` int(4) NOT NULL,
  `modelscale` varchar(7) COLLATE utf8_bin NOT NULL,
  `countgoods` varchar(10) COLLATE utf8_bin NOT NULL,
  `deviceipport` int(5) NOT NULL,
  `deviceiphost` varchar(64) COLLATE utf8_bin NOT NULL,
  `devicehwbaud` int(5) NOT NULL,
  `devicehwport` varchar(64) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.sprtables
CREATE TABLE IF NOT EXISTS `sprtables` (
  `id` int(12) NOT NULL,
  `name` varchar(64) COLLATE utf8_bin NOT NULL,
  `active` varchar(1) COLLATE utf8_bin NOT NULL,
  `price` float NOT NULL,
  `alcgoods` varchar(1) COLLATE utf8_bin NOT NULL,
  `idhall` int(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.sprusers
CREATE TABLE IF NOT EXISTS `sprusers` (
  `userid` int(12) NOT NULL,
  `name` varchar(64) COLLATE utf8_bin NOT NULL,
  `fullname` varchar(254) COLLATE utf8_bin NOT NULL,
  `weightgood` varchar(1) COLLATE utf8_bin NOT NULL,
  `alcgoods` varchar(1) COLLATE utf8_bin NOT NULL,
  `barcodes` varchar(13) COLLATE utf8_bin NOT NULL,
  `pincode` varchar(4) COLLATE utf8_bin NOT NULL,
  `password` varchar(32) COLLATE utf8_bin NOT NULL,
  `interface` varchar(1) COLLATE utf8_bin NOT NULL,
  `article` varchar(48) COLLATE utf8_bin NOT NULL,
  `groupid` varchar(1) COLLATE utf8_bin NOT NULL,
  `freeprice` varchar(1) COLLATE utf8_bin NOT NULL,
  `findvisual` varchar(1) COLLATE utf8_bin NOT NULL,
  `storno` varchar(1) COLLATE utf8_bin NOT NULL,
  `cancelcheck` varchar(1) COLLATE utf8_bin NOT NULL,
  `returncheck` varchar(1) COLLATE utf8_bin NOT NULL,
  `reportx` varchar(1) COLLATE utf8_bin NOT NULL,
  `reportkkm` varchar(1) COLLATE utf8_bin NOT NULL,
  `deferredcheck` varchar(1) COLLATE utf8_bin NOT NULL,
  `discount` varchar(1) COLLATE utf8_bin NOT NULL,
  `editsoft` varchar(1) COLLATE utf8_bin NOT NULL,
  `edithw` varchar(1) COLLATE utf8_bin NOT NULL,
  `editgoods` varchar(1) COLLATE utf8_bin NOT NULL,
  `editusers` varchar(1) COLLATE utf8_bin NOT NULL,
  `exittoos` varchar(1) COLLATE utf8_bin NOT NULL,
  `enterukm` varchar(1) COLLATE utf8_bin NOT NULL,
  `entercash` varchar(1) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.stacksender
CREATE TABLE IF NOT EXISTS `stacksender` (
  `type` varchar(32) COLLATE utf8_bin NOT NULL,
  `value` varchar(128) COLLATE utf8_bin NOT NULL,
  `sending` varchar(1) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица egais1.ticket
CREATE TABLE IF NOT EXISTS `ticket` (
  `dateDoc` date NOT NULL,
  `docid` varchar(48) COLLATE utf8_bin NOT NULL,
  `uid` varchar(48) COLLATE utf8_bin NOT NULL,
  `regid` varchar(20) COLLATE utf8_bin NOT NULL,
  `numDoc` varchar(20) COLLATE utf8_bin NOT NULL,
  `comment` mediumtext COLLATE utf8_bin NOT NULL,
  `datestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Экспортируемые данные не выделены.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
