﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытияДокумента = УчетНДСКлиент.ПараметрыИсправленияСчетаФактурыПолученного(ПараметрКоманды);
	
	ОткрытьФорму("Документ."+ПараметрыОткрытияДокумента.ИмяДокумента+".ФормаОбъекта", ПараметрыОткрытияДокумента.ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
