﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытия = ОбщегоНазначенияБПКлиентСервер.ПараметрыОткрытияФормыСОжиданием(ПараметрыВыполненияКоманды);
	ПараметрыОткрытия.ИмяФормы = "Документ.ПередачаТоваров.ФормаСписка";
	ПараметрыОткрытия.Уникальность = "ФормаСписка_ПередачаПродукцииЗаказчику";

	Отбор = Новый Структура("ВидОперации",
		ПредопределенноеЗначение("Перечисление.ВидыОперацийПередачаТоваров.ИзПереработки"));
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	
	ОбщегоНазначенияБПКлиент.ОткрытьФормуСОжиданием(ПараметрыОткрытия, ПараметрыФормы);
	
КонецПроцедуры
