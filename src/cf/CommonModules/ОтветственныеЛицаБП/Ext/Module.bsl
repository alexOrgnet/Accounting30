﻿////////////////////////////////////////////////////////////////////////////////
// Ответственные лица: процедуры и функции для работы с ответственным лицами.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает информацию об ответственном лице организации - какую роль в организации он выполняет,
// на какие действия уполномочен.
// Эта информация может использоваться, например, для вывода в печатной форме.
//
// Параметры:
//  ФизическоеЛицо - СправочникСсылка.ФизическиеЛица - ответственное лицо (например, оформляющее документ)
//  Организация    - СправочникСсылка.Организации - от лица какой организации действует (подписывает документ)
//  Период         - Дата - период события
//  Подразделение  - СправочникСсылка.ПодразделенияОрганизаций - в каком подразделении действует
//                 - Неопределено - информация об ответственных лицах подразделений не учитывается
// 
// Возвращаемое значение:
//  Структура - см. ПустаяСтруктураУполномоченногоЛица
//
Функция ПолномочияОтветственного(ФизическоеЛицо, Организация, Период, Подразделение = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		Возврат ПустаяСтруктураУполномоченногоЛица();
	КонецЕсли;
	
	ВсеОтветственные = ОтветственныеЛица(Организация, Период, Подразделение);
	Для Каждого МетаданныеЗначения Из Метаданные.Перечисления.ОтветственныеЛицаОрганизаций.ЗначенияПеречисления Цикл
		
		ПрефиксПоля = МетаданныеЗначения.Имя;
		ФизическоеЛицоОтветственного = Неопределено;
		
		Если Не ВсеОтветственные.Свойство(ПрефиксПоля, ФизическоеЛицоОтветственного) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ФизическоеЛицоОтветственного <> ФизическоеЛицо Тогда
			Продолжить;
		КонецЕсли;
		
		Описание = ПустаяСтруктураУполномоченногоЛица();
		Описание.ФизическоеЛицо = ФизическоеЛицо;
		
		Для Каждого ПолеОписания Из Описание Цикл
			ИмяПоляВсеОтветственные = ПрефиксПоля + ПолеОписания.Ключ;
			Значение = Неопределено;
			Если Не ВсеОтветственные.Свойство(ИмяПоляВсеОтветственные, Значение) Тогда
				Продолжить;
			КонецЕсли;
			Описание[ПолеОписания.Ключ] = Значение;
		КонецЦикла;
		
		Возврат Описание;
		
	КонецЦикла;
	
	Описание = ПустаяСтруктураУполномоченногоЛица();
	Описание.ФизическоеЛицо = ФизическоеЛицо;
	
	ДанныеФизлица = УчетЗарплаты.ДанныеФизическихЛиц(Организация, ФизическоеЛицо, Период);
	ЗаполнитьЗначенияСвойств(Описание.ФИО, ДанныеФизлица);
	
	Возврат Описание;
	
КонецФункции

// Функция подбирает вероятную должность ответственного лица из справочника "Должности".
// 
Функция ПодобратьВероятнуюДолжностьОтветственногоЛица(ОтветственноеЛицо) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ОтветственноеЛицо) Тогда
		Возврат Неопределено;
	КонецЕсли;	
	
	Если ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.Руководитель Тогда
		НаименованиеДолжности1	= НСтр("ru='Генеральный директор'");
		НаименованиеДолжности2	= НСтр("ru='%[Дд]иректор%'");
	ИначеЕсли ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер Тогда
		НаименованиеДолжности1	= НСтр("ru='Главный бухгалтер'");
		НаименованиеДолжности2	= НСтр("ru='%[Бб]ухгалтер%'");
	ИначеЕсли ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.Кассир Тогда
		НаименованиеДолжности1	= НСтр("ru='Кассир'");
		НаименованиеДолжности2	= НСтр("ru='%[Кк]ассир%'");
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос	= Новый Запрос;
	
	Запрос.УстановитьПараметр("НаименованиеДолжности1", НаименованиеДолжности1);
	Запрос.УстановитьПараметр("НаименованиеДолжности2", НаименованиеДолжности2);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	1 КАК Порядок,
	|	Должности.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Должности КАК Должности
	|ГДЕ
	|	Должности.Наименование ПОДОБНО &НаименованиеДолжности1
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2,
	|	Должности.Ссылка
	|ИЗ
	|	Справочник.Должности КАК Должности
	|ГДЕ
	|	Должности.Наименование ПОДОБНО &НаименованиеДолжности2
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка	= РезультатЗапроса.Выбрать();
	Если НЕ Выборка.Следующий() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Выборка.Ссылка;
	
КонецФункции

// Функция возвращает пустую структуру со сведениями об ответственных лицах.
//
// Возвращаемое значение:
//	Структура - Структура с ключами, соответствующими имени значений перечисления ОтветственныеЛица вида:
//		* Руководитель - СправочникСсылка.ФизическиеЛица.
//		* РуководительФИО - структура (Фамилия, Имя, Отчество, Представление).
//		* РуководительПредставление - строка, Фамилия И.О.
//		* РуководительДолжность - СправочникСсылка.Должности.
//		* РуководительДолжностьПредставление - строка, название должности.
//
Функция ПустаяСтруктураОтветственныхЛиц() Экспорт

	ПустоеФизЛицо	 = Справочники.ФизическиеЛица.ПустаяСсылка();
	ПустаяДолжность	 = Справочники.Должности.ПустаяСсылка();

	МассивОтветственныхЛиц = Новый Массив;
	МассивОтветственныхЛиц.Добавить("Руководитель");
	МассивОтветственныхЛиц.Добавить("ГлавныйБухгалтер");
	МассивОтветственныхЛиц.Добавить("РуководительКадровойСлужбы");
	МассивОтветственныхЛиц.Добавить("Кассир");
	МассивОтветственныхЛиц.Добавить("ОтветственныйЗаБухгалтерскиеРегистры");
	МассивОтветственныхЛиц.Добавить("ОтветственныйЗаНалоговыеРегистры");    
	МассивОтветственныхЛиц.Добавить("УполномоченныйПредставитель");
	МассивОтветственныхЛиц.Добавить("Исполнитель");
	МассивОтветственныхЛиц.Добавить("ОтветственныйЗаВУР");
	
	Результат = Новый Структура();
	
	Для Каждого ВидОтветственногоЛица Из МассивОтветственныхЛиц Цикл
	
		ФИО = Новый Структура;
		ФИО.Вставить("Фамилия", 		"");
		ФИО.Вставить("Имя", 			"");
		ФИО.Вставить("Отчество", 		"");
		ФИО.Вставить("Представление", 	""); // Фамилия И.О.
	
		Результат.Вставить(ВидОтветственногоЛица, 					ПустоеФизлицо);
		Результат.Вставить(ВидОтветственногоЛица + "ФИО", 			ФИО);
		Результат.Вставить(ВидОтветственногоЛица + "Представление", ""); 				// Фамилия И.О.
		Результат.Вставить(ВидОтветственногоЛица + "Должность", 	ПустаяДолжность);   
		Результат.Вставить(ВидОтветственногоЛица + "ДолжностьПредставление", "");		// Наименование должности
	
	КонецЦикла;

	Возврат Результат;

КонецФункции

// Функция возвращает структуру со сведениями об ответственных лицах.
//
// Параметры:
//  Организация   - СправочникСсылка.Организации - Организация, для которой нужно определить ответственных лиц.
//  ДатаСреза     - Дата - Дата со временем, на которые необходимо определить сведения.
//  Подразделение - СправочникСсылка.ПодразделенияОрганизаций - Подразделение, для которого необходимо определить ответственных лиц.
//
// Возвращаемое значение:
//	Структура - Структура с ключами, соответствующими имени значений перечисления ОтветственныеЛица вида:
//		* Руководитель - СправочникСсылка.ФизическиеЛица.
//		* РуководительФИО - структура (Фамилия, Имя, Отчество, Представление).
//		* РуководительПредставление - строка, Фамилия И.О.
//		* РуководительДолжность - СправочникСсылка.Должности.
//		* РуководительДолжностьПредставление - строка, название должности.
//
Функция ОтветственныеЛица(Организация, ДатаСреза, Подразделение = Неопределено) Экспорт

	// В текущую функцию в качестве ДатаСреза обычно передается дата самого документа 
	// вместе со временем. Чтобы уменьшить число разных значений в кэше повторно используемых
	// вызовов, получим для этой даты значение последнего изменения в ответственных лица
	// и для него уже вызовем функцию из модуля с повторным использованием возвращаемых значений.
	ПриведеннаяДатаСреза = '0001-01-01';
	
	МассивДатИзменения = ОтветственныеЛицаБППовтИсп.ДатыИзмененияОтветственныхЛицОрганизаций(Организация);
	Для Каждого ДатаИзменения Из МассивДатИзменения Цикл
		Если ДатаИзменения <= ДатаСреза Тогда
			ПриведеннаяДатаСреза = Макс(ПриведеннаяДатаСреза, ДатаИзменения);
		КонецЕсли;
	КонецЦикла;
	
	Результат = ОтветственныеЛицаБППовтИсп.ОтветственныеЛица(Организация, ПриведеннаяДатаСреза, Подразделение);

	Возврат Результат;

КонецФункции

// Функция возвращает пустую структуру с описанием реквизитов подписи полномоченного лица.
//
Функция ПустаяСтруктураУполномоченногоЛица() Экспорт 
	
	ПустоеФизЛицо   = Справочники.ФизическиеЛица.ПустаяСсылка();
	ПустоеОснование = Справочники.ОснованияПраваПодписи.ПустаяСсылка();
	ПустаяДолжность = Справочники.Должности.ПустаяСсылка();

	Результат = Новый Структура();
	
	ФИО = Новый Структура;
	ФИО.Вставить("Фамилия", 		"");
	ФИО.Вставить("Имя", 			"");
	ФИО.Вставить("Отчество", 		"");
	ФИО.Вставить("Представление", 	""); // Фамилия И.О.
	
	Результат.Вставить("ФизическоеЛицо", 					ПустоеФизлицо);
	Результат.Вставить("ФИО", 								ФИО);
	Результат.Вставить("Должность", 						ПустаяДолжность);   
	Результат.Вставить("ДолжностьПредставление",			"");		// Наименование должности
	Результат.Вставить("ОснованиеПраваПодписи", 			ПустоеОснование);
	Результат.Вставить("ОснованиеПраваПодписиПредставление", "");		// Текст основания
	
	Возврат Результат;

КонецФункции

// Функция возвращает пустую структуру с описанием реквизитов подписи по умолчанию указанного пользователя.
//
Функция ПустаяСтруктураУполномоченныхЛиц() Экспорт 
	
	ПустоеФизЛицо   = Справочники.ФизическиеЛица.ПустаяСсылка();
	ПустоеОснование = Справочники.ОснованияПраваПодписи.ПустаяСсылка();
	
	Результат = Новый Структура();
	Результат.Вставить("Руководитель", 				ПустоеФизЛицо);
	Результат.Вставить("РуководительНаОсновании", 	ПустоеОснование);
	Результат.Вставить("ГлавныйБухгалтер",			ПустоеФизЛицо);
	Результат.Вставить("ГлавныйБухгалтерНаОсновании",ПустоеОснование);
	Результат.Вставить("ОтветственныйЗаОформление",  ПустоеФизЛицо);

	Возврат Результат;

КонецФункции

// Функция возвращает структуру с реквизитами подписи указанного физического лица с указанным основанием права подписи.
//
// Параметры:
//	Организация 	- СправочникСсылка.Организации
//	ФизическоеЛицо 	- СправочникСсылка.ФизическиеЛица
//	ОснованиеПраваПодписи = СправочникСсылка.ОснованияПраваПодписи, если не заполнено - будут получены реквизиты физ.лица
//	ДатаСреза	- Дата, на которую будут получены данные Физ.лица
//
Функция РеквизитыПодписиУполномоченногоЛица(Организация, ФизическоеЛицо,ОснованиеПраваПодписи = Неопределено, ДатаСреза = Неопределено) Экспорт 
	
	Возврат ОтветственныеЛицаБППереопределяемый.РеквизитыПодписиУполномоченногоЛица(Организация, ФизическоеЛицо,ОснованиеПраваПодписи,ДатаСреза);

КонецФункции

// Функция возвращает структуру с описанием реквизитов полномочий указанного пользователя.
//
// Параметры:
//	Организация 	- СправочникСсылка.Организация
//	Пользователь 	- СправочникСсылка.Пользователи, если не заполнен, то для всех пользователей.
//
Функция ДанныеУполномоченногоЛица(Организация, Пользователь = Неопределено,ПодразделениеОрганизации = Неопределено) Экспорт 
	
	Возврат ОтветственныеЛицаБППереопределяемый.ДанныеУполномоченногоЛица(Организация, Пользователь,ПодразделениеОрганизации);

КонецФункции

// Процедура заполняет в документе реквизиты, связанные с уполномоченными лицами.
//
// Параметры:
//  ДокументОбъект - документ, в котором требуется заполнить реквизиты.
//  ДатаСреза - Дата, на которую будут получены уполномоченные лица
//
Процедура УстановитьОтветственныхЛиц(ДокументОбъект, ДатаСреза = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ДатаСреза) Тогда
		ДатаСреза = ДокументОбъект.Дата;
	КонецЕсли;
	
	ДанныеЗаполнения	= Новый Структура("Руководитель, ГлавныйБухгалтер,
		|ЗаРуководителяНаОсновании, ЗаГлавногоБухгалтераНаОсновании, ОтветственныйЗаОформление");
		
	ПодразделениеОрганизации = Неопределено;
		
	Если ТипЗнч(ДокументОбъект.Ссылка) = Тип("ДокументСсылка.СчетФактураВыданный") тогда
		
		Если ДокументОбъект.ДокументыОснования.Количество()>0 Тогда
			ДокументОснование = ДокументОбъект.ДокументыОснования[0].ДокументОснование;
		Иначе 
			ДокументОснование = ДокументОбъект.ДокументОснование;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДокументОснование) 
				И ОбщегоНазначения.ЕстьРеквизитОбъекта("ПодразделениеОрганизации", ДокументОснование.Метаданные())Тогда
				
				ПодразделениеОрганизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование,"ПодразделениеОрганизации");
				
		КонецЕсли;
		
	ИначеЕсли ОбщегоНазначения.ЕстьРеквизитОбъекта("ПодразделениеОрганизации", ДокументОбъект.Ссылка.Метаданные()) ТОгда
		
		ПодразделениеОрганизации	= ДокументОбъект.ПодразделениеОрганизации;
		
	КонецЕсли;
	
	ДанныеУполномоченныхЛиц = ДанныеУполномоченногоЛица(ДокументОбъект.Организация, ДокументОбъект.Ответственный, ПодразделениеОрганизации);
	
	Руководители = ОтветственныеЛица(ДокументОбъект.Организация, ДатаСреза);

	Если ЗначениеЗаполнено(ДанныеУполномоченныхЛиц.Руководитель) Тогда
		ДанныеЗаполнения.Руководитель				= ДанныеУполномоченныхЛиц.Руководитель;
		ДанныеЗаполнения.ЗаРуководителяНаОсновании	= ДанныеУполномоченныхЛиц.РуководительНаОсновании;
	Иначе
		ДанныеЗаполнения.Руководитель				= Руководители.Руководитель;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеУполномоченныхЛиц.ГлавныйБухгалтер) Тогда
		ДанныеЗаполнения.ГлавныйБухгалтер					= ДанныеУполномоченныхЛиц.ГлавныйБухгалтер;
		ДанныеЗаполнения.ЗаГлавногоБухгалтераНаОсновании	= ДанныеУполномоченныхЛиц.ГлавныйБухгалтерНаОсновании;
	Иначе
		ДанныеЗаполнения.ГлавныйБухгалтер					= Руководители.ГлавныйБухгалтер;
	КонецЕсли;
	
	ДанныеЗаполнения.Вставить("ОтветственныйЗаОформление", ДанныеУполномоченныхЛиц.ОтветственныйЗаОформление);
	ДанныеЗаполнения.Вставить("Исполнитель",			ДанныеЗаполнения.Руководитель);
	ДанныеЗаполнения.Вставить("ИсполнительНаОсновании",	ДанныеЗаполнения.ЗаРуководителяНаОсновании);
	
	ЗаполнитьЗначенияСвойств(ДокументОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

// Возвращает ответственное лицо на складе на указанную дату
//
// Параметры:
//	Склад - СправочникСсылка.Склады - Склад, для которого нужно получить ответственное лицо.
//	Дата - Дата - Дата, на которую нужно получить ответственное лицо.
//
// Возвращаемое значение:
//	- СправочникСсылка.ФизическиеЛица - Ответственное лицо склада.
//
Функция ОтветственноеЛицоНаСкладе(Склад, Дата) Экспорт
	
	Возврат ОтветственныеЛицаБППереопределяемый.ОтветственноеЛицоНаСкладе(Склад, Дата);

КонецФункции

// Обновляет данные об уполномоченных лицах по данным документа.
Процедура УстановитьПодписиПоУмолчанию(ДокументСсылка, ПараметрыЗаписи) Экспорт
		
	Если Не ПараметрыЗаписи.Свойство("ПодписиДляИзменения") тогда
		Возврат;			
	КонецЕсли;

	УстановитьПривилегированныйРежим(Истина);
	
	ПодписиДляИзменения = ПараметрыЗаписи.ПодписиДляИзменения;
	
	УчитыватьПодразделение = БухгалтерскийУчетПереопределяемый.ВестиУчетПоПодразделениям()
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("ПодразделениеОрганизации", ДокументСсылка.Метаданные());
	УполномоченныеЛица = РегистрыСведений.УполномоченныеЛицаОрганизаций.СоздатьНаборЗаписей().ВыгрузитьКолонки();
	
	РеквизитыДокумента = Новый Структура;
	РеквизитыДокумента.Вставить("Организация");
	РеквизитыДокумента.Вставить("Пользователь", "Ответственный");
	Для каждого РеквизитПодписи из ПодписиДляИзменения Цикл
		РеквизитыДокумента.Вставить(РеквизитПодписи.Ключ);
		РеквизитыДокумента.Вставить(РеквизитПодписи.Значение);
	КонецЦикла;
		
	Если УчитыватьПодразделение тогда
		РеквизитыДокумента.Вставить("ПодразделениеОрганизации");
		РеквизитыДокумента.Вставить("ЭтоОбособленноеПодразделение", "ПодразделениеОрганизации.ОбособленноеПодразделение");
	КонецЕсли;				
		
	ДанныеДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, РеквизитыДокумента);
	
	НачатьТранзакцию();
	
	Если Не ДанныеДокумента.Свойство("ЭтоОбособленноеПодразделение") ИЛИ ДанныеДокумента.ЭтоОбособленноеПодразделение = Ложь тогда
		ДанныеДокумента.Вставить("ПодразделениеОрганизации",Справочники.ПодразделенияОрганизаций.ПустаяСсылка());
	КонецЕсли;
		
	Для каждого РеквизитПодписи из ПодписиДляИзменения Цикл
		
		Если РеквизитПодписи.Ключ = "Исполнитель" или РеквизитПодписи.Ключ = "Руководитель" тогда
			РольПодписи = Перечисления.ОтветственныеЛицаОрганизаций.Руководитель;
		ИначеЕсли РеквизитПодписи.Ключ = "ОтветственныйЗаОформление" Тогда 
			РольПодписи = Перечисления.ОтветственныеЛицаОрганизаций.ОтветственныйЗаОформление;
		Иначе
			РольПодписи = Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер;
		КонецЕсли;
		
		ПроверяемаяЗапись = УполномоченныеЛица.Добавить();
		ЗаполнитьЗначенияСвойств(ПроверяемаяЗапись, ДанныеДокумента);
		ПроверяемаяЗапись.УполномоченноеЛицо	= ДанныеДокумента[РеквизитПодписи.Ключ];
		ПроверяемаяЗапись.ОснованиеПраваПодписи	= ДанныеДокумента[РеквизитПодписи.Значение];
		ПроверяемаяЗапись.ЗаКогоПодписывает		= РольПодписи;
		
	КонецЦикла;

	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.УполномоченныеЛицаОрганизаций");
	ЭлементБлокировки.ИсточникДанных = УполномоченныеЛица;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Организация",              "Организация");
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ПодразделениеОрганизации", "ПодразделениеОрганизации");
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Пользователь",             "Пользователь");
	Блокировка.Заблокировать();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УполномоченныеЛицаДляИзменения.Организация,
	|	УполномоченныеЛицаДляИзменения.ПодразделениеОрганизации,
	|	УполномоченныеЛицаДляИзменения.Пользователь,
	|	УполномоченныеЛицаДляИзменения.ЗаКогоПодписывает,
	|	УполномоченныеЛицаДляИзменения.УполномоченноеЛицо,
	|	УполномоченныеЛицаДляИзменения.ОснованиеПраваПодписи
	|ПОМЕСТИТЬ ВТ_ДанныеДляИзменения
	|ИЗ
	|	&УполномоченныеЛицаДляИзменения КАК УполномоченныеЛицаДляИзменения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ДанныеДляИзменения.Организация,
	|	ВТ_ДанныеДляИзменения.ПодразделениеОрганизации,
	|	ВТ_ДанныеДляИзменения.Пользователь,
	|	ВТ_ДанныеДляИзменения.ЗаКогоПодписывает,
	|	ВТ_ДанныеДляИзменения.УполномоченноеЛицо,
	|	ВТ_ДанныеДляИзменения.ОснованиеПраваПодписи,
	|	ВЫБОР
	|		КОГДА ВТ_ДанныеДляИзменения.ОснованиеПраваПодписи = ЗНАЧЕНИЕ(Справочник.ОснованияПраваПодписи.ПустаяСсылка)
	|				И НЕ ВТ_ДанныеДляИзменения.ЗаКогоПодписывает = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.ОтветственныйЗаОформление)
	|			ТОГДА ""Удалить""
	|		ИНАЧЕ ""Изменить""
	|	КОНЕЦ КАК ВыполняемоеДействие
	|ИЗ
	|	ВТ_ДанныеДляИзменения КАК ВТ_ДанныеДляИзменения
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УполномоченныеЛицаОрганизаций КАК УполномоченныеЛицаОрганизаций
	|		ПО ВТ_ДанныеДляИзменения.Организация = УполномоченныеЛицаОрганизаций.Организация
	|			И ВТ_ДанныеДляИзменения.ПодразделениеОрганизации = УполномоченныеЛицаОрганизаций.ПодразделениеОрганизации
	|			И ВТ_ДанныеДляИзменения.Пользователь = УполномоченныеЛицаОрганизаций.Пользователь
	|			И ВТ_ДанныеДляИзменения.ЗаКогоПодписывает = УполномоченныеЛицаОрганизаций.ЗаКогоПодписывает
	|			И ВТ_ДанныеДляИзменения.УполномоченноеЛицо = УполномоченныеЛицаОрганизаций.УполномоченноеЛицо
	|			И ВТ_ДанныеДляИзменения.ОснованиеПраваПодписи = УполномоченныеЛицаОрганизаций.ОснованиеПраваПодписи
	|ГДЕ
	|	УполномоченныеЛицаОрганизаций.Организация ЕСТЬ NULL ";
	
	Запрос.УстановитьПараметр("УполномоченныеЛицаДляИзменения",УполномоченныеЛица);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Попытка
		
		Пока Выборка.Следующий() Цикл
				
			Запись = РегистрыСведений.УполномоченныеЛицаОрганизаций.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(Запись, Выборка);
				
			Если Выборка.ВыполняемоеДействие = "Изменить" тогда
				Запись.Записать();
			ИначеЕсли Выборка.ВыполняемоеДействие = "Удалить" тогда
				Запись.Удалить();
			КонецЕсли;
				
		КонецЦикла;
		
	ЗафиксироватьТранзакцию();
	
	Исключение
	
	ОтменитьТранзакцию();
	
	КонецПопытки;

КонецПроцедуры

Процедура ПроверитьИзменениеПодписейДокумента(ТекущийОбъект, РеквизитыПодписи, ПараметрыЗаписи) Экспорт
	
	ПодписиДляИзменения = Новый Структура;
	
	ОбновитьВсеПодписи = Ложь;
	
	Если ЗначениеЗаполнено(ТекущийОбъект.ссылка) тогда
	
		РеквизитыДокумента = Новый Структура;
		
		Для каждого РеквизитПодписи из РеквизитыПодписи Цикл
			РеквизитыДокумента.Вставить(РеквизитПодписи.Значение);
		КонецЦикла;
		
		РеквизитыДокумента.Вставить("Ответственный","Ответственный");
		
		УчитыватьПодразделение = БухгалтерскийУчетПереопределяемый.ВестиУчетПоПодразделениям()
			И ОбщегоНазначения.ЕстьРеквизитОбъекта("ПодразделениеОрганизации", ТекущийОбъект.Ссылка.Метаданные());
		
		Если УчитыватьПодразделение тогда 
			РеквизитыДокумента.Вставить("ПодразделениеОрганизации");
			РеквизитыДокумента.Вставить("ЭтоОбособленноеПодразделение", "ПодразделениеОрганизации.ОбособленноеПодразделение");
		КонецЕсли;
		
		РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ТекущийОбъект.Ссылка, РеквизитыДокумента);
				
				
		Если УчитыватьПодразделение Тогда
			Если РеквизитыДокумента.ПодразделениеОрганизации <> ТекущийОбъект.ПодразделениеОрганизации
				И (РеквизитыДокумента.ЭтоОбособленноеПодразделение = Истина 
					ИЛИ ТекущийОбъект.ПодразделениеОрганизации.ОбособленноеПодразделение = Истина) тогда
				
				ОбновитьВсеПодписи = Истина;
				
			КонецЕсли;
		КонецЕсли;
		
		ОбновитьВсеПодписи = ОбновитьВсеПодписи ИЛИ РеквизитыДокумента.Ответственный <> ТекущийОбъект.Ответственный;
		
		Если ОбновитьВсеПодписи Тогда
			ПодписиДляИзменения = РеквизитыПодписи;
		Иначе
			Для каждого РеквизитПодписи из РеквизитыПодписи Цикл
				Если ТекущийОбъект[РеквизитПодписи.Значение] <> РеквизитыДокумента[РеквизитПодписи.Значение] тогда
					ПодписиДляИзменения.Вставить(РеквизитПодписи.Ключ,РеквизитПодписи.Значение);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
			
	Иначе
		
		ПодписиДляИзменения = РеквизитыПодписи;
		
	КонецЕсли;
	
	Если ПодписиДляИзменения.Количество()>0 тогда
		ПараметрыЗаписи.Вставить("ПодписиДляИзменения",ПодписиДляИзменения);
	КонецЕсли;
	 
КонецПроцедуры

Функция ПолучитьСоздатьФизЛицо(ДанныеФизЛица) Экспорт
	
	ФизическоеЛицо = Неопределено;
	
	Фамилия = "";
	Имя = "";
	Отчество = "";
	ИНН = "";
	Пол = "";
	ДанныеФизЛица.Свойство("Фамилия", Фамилия);
	ДанныеФизЛица.Свойство("Имя", Имя);
	ДанныеФизЛица.Свойство("Отчество", Отчество);
	ДанныеФизЛица.Свойство("ИНН", ИНН);
	НаименованиеФизЛица = КадровыйУчетКлиентСервер.ПолноеНаименованиеСотрудника(Фамилия, Имя, Отчество, "");
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("Наименование", НаименованиеФизЛица);
	Запрос.Параметры.Вставить("ИНН", ИНН);
	ТекстЗапроса = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ФизическиеЛица.Ссылка
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФИзическиеЛица
	|ГДЕ
	|	ФизическиеЛица.Наименование = &Наименование
	|	&ИНН";
	
	Если ПустаяСтрока(ИНН) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ИНН","");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ИНН"," И ФизическиеЛица.ИНН = &ИНН ");
	КонецЕсли;
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		ФизическоеЛицо = Выборка.Ссылка;
		
	Иначе
		
		НовоеФизлицо = Справочники.ФизическиеЛица.СоздатьЭлемент();
		НовоеФизлицо.ИНН = ИНН;
		
		НовоеФизлицо.ФИО = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1 %2 %3'"), Фамилия, Имя, Отчество);
		НовоеФизлицо.Наименование = НаименованиеФизЛица;
		
		НовоеФизлицо.Пол = СотрудникиКлиентСервер.ОпределитьПолПоОтчеству(Отчество);
		Если НЕ ЗначениеЗаполнено(НовоеФизлицо.Пол) Тогда
			НовоеФизлицо.Пол = Перечисления.ПолФизическогоЛица.Мужской;
		КонецЕсли;
		НовоеФизлицо.Записать();
		
		ФИОФизическихЛиц = РегистрыСведений.ФИОФизическихЛиц.СоздатьМенеджерЗаписи();
		ФИОФизическихЛиц.Период = Дата(1899, 12, 31);
		ФИОФизическихЛиц.ФизическоеЛицо = НовоеФизлицо.Ссылка;
		ФИОФизическихЛиц.Фамилия = Фамилия;
		ФИОФизическихЛиц.Имя = Имя;
		ФИОФизическихЛиц.Отчество = Отчество;
		ФИОФизическихЛиц.Записать();
		
		ФизическоеЛицо = НовоеФизлицо.Ссылка;
		
	КонецЕсли;
	
	Возврат ФизическоеЛицо;
	
КонецФункции

Функция ПолучитьСоздатьДолжность(НазваниеДолжности) Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("Наименование", НазваниеДолжности);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Должности.Ссылка
	|ИЗ
	|	Справочник.Должности КАК Должности
	|ГДЕ
	|	Должности.Наименование = &Наименование";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Должность = Выборка.Ссылка;
	Иначе
		ДолжностьРуководителя = Справочники.Должности.СоздатьЭлемент();
		ДолжностьРуководителя.Наименование = НазваниеДолжности;
		ДолжностьРуководителя.Записать();
		Должность = ДолжностьРуководителя.Ссылка;
	КонецЕсли;
	
	Возврат Должность;
	
КонецФункции

// Возвращает фактическую должность для ответственного лица по кадровым данным либо вероятную должность по роли.
//
// Параметры:
//	Организация - СправочникСсылка.Организации - Организация, в которой лицо является ответственным.
//	ФизическоеЛицо - СправочникСсылка.ФизическиеЛица - Лицо, которое является ответственным.
//	ОтветственноеЛицо - ПеречислениеСсылка.ОтветственныеЛицаОрганизаций - Роль ответственного лица.
//
// Возвращаемое значение:
//	СправочникСсылка.Должности - Должность ответственного лица.
//
Функция ДолжностьОтветственногоЛица(Организация, ФизическоеЛицо, ОтветственноеЛицо) Экспорт
	
	Если ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		ДанныеОтветственногоЛица = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(Организация, ФизическоеЛицо, ТекущаяДатаСеанса());
		Должность = ДанныеОтветственногоЛица.Должность;
		
		Если ЗначениеЗаполнено(ДанныеОтветственногоЛица.Должность) Тогда
			Возврат ДанныеОтветственногоЛица.Должность;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ОтветственныеЛицаБП.ПодобратьВероятнуюДолжностьОтветственногоЛица(ОтветственноеЛицо);
	
КонецФункции

#КонецОбласти