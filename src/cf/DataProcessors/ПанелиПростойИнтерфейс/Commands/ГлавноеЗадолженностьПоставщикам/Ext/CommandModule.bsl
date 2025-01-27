﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("КлючВарианта", "ЗадолженностьПоставщикам");
	
	ФормаОтчета = ПолучитьФорму("Отчет.ЗадолженностьПоставщикам.ФормаОбъекта", ПараметрыОтчета,
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
	ФормаОтчета.ПодключитьОбработчикОжидания("Подключаемый_СформироватьПриОткрытии",
		БухгалтерскиеОтчетыКлиент.ИнтервалЗапускаФормированияОтчетаПриОткрытии(),
		Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(ФормаОтчета.Элементы.Результат,
		"ФормированиеОтчета");
	ФормаОтчета.Открыть();
	
КонецПроцедуры
