﻿
&НаСервере
Процедура СоздатьОплатуНаСервере()
	Док=Документы.ПлатежноеПоручение.СоздатьДокумент();
	ЗаполнитьЗначенияСвойств(Док,ЭтаФорма);
	Док.Дата = ТекущаяДатаСеанса();
	
	//++ ВЦК Андрей	01.06.2022 
	//третье изменение гита
	//-- ВЦК Андрей	01.06.2022
	Док.ПоказательНомера = "0";
	Док.ПоказательОснования  = "0";
	Док.ПоказательПериода = "0";
	Док.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	Док.Записать(РежимЗаписиДокумента.Проведение);
	
	Сообщить("Сформировано ПП: " + Строка(Док));
	
	
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОплату(Команда)
	СоздатьОплатуНаСервере();
	//СтрокаШтрафа=""; ВЦК 2022_06_11
	ЭтаФорма.ТекущийЭлемент = Элементы.СтрокаШтрафа;

КонецПроцедуры

Функция ПолучитьСчет(Контр)
	Запрос = Новый Запрос;
	ТекстЗапроса =
	"ВЫБРАТЬ 
	|	БанковскиеСчета.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.БанковскиеСчета КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.Владелец = &ВладелецСчета
	|	И БанковскиеСчета.ПометкаУдаления = ЛОЖЬ
	|	И БанковскиеСчета.ВалютаДенежныхСредств = &Валюта
	|	";
	
	Запрос.УстановитьПараметр("ВладелецСчета",    Контр);
	Запрос.УстановитьПараметр("Валюта",           ВалютаДокумента);
		
	Запрос.Текст = ТекстЗапроса;
	Результат    = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		НовыйСчет = Выборка.Ссылка;
		Возврат НовыйСчет;
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	//ИННПлательщика=Организация.ИНН;
	//КПППлательщика=Организация.КПП;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура СтрокаШтрафаПриИзмененииНаСервере()
	МассивСтрок=СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаШтрафа,"/",ложь);
	Контрагент=Справочники.Контрагенты.НайтиПоРеквизиту("Инн",СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(МассивСтрок[6],"=",ложь)[1]);
	//Если Контрагент<>Справочники.Контрагенты.ПустаяСсылка() Тогда
		//ИННПолучателя=Контрагент.ИНН;
		//КПППолучателя=Контрагент.КПП;
		//СчетКонтрагента=Контрагент.ОсновнойБанковскийСчет;//ПолучитьСчет(Контрагент);
		//ТекстПолучателя=Контрагент.НаименованиеПолное;
	//*КонецЕсли;
	//СтатусСоставителя="08";
	//КодБК= СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(МассивСтрок[8],"=",ложь)[1];
	//КодОКАТО=СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(МассивСтрок[9],"=",ложь)[1];
	//ИдентификаторПлатежа=СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(МассивСтрок[14],"=",ложь)[1];
	//НазначениеПлатежа="УИН "+ИдентификаторПлатежа +"/// Штраф по постановлению "+ИдентификаторПлатежа+" от "+СтрЗаменить(СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(МассивСтрок[17],"=",ложь)[1],"ю",".");
	ЛьготнаяДата=Дата(СтрЗаменить(СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(МассивСтрок[20],"=",ложь)[1],"ю",".")+" 00:00:00");
	Если ЛьготнаяДата<НачалоДня(ТекущаяДатаСеанса()) Тогда
		СуммаДокументаСтр=СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(МассивСтрок[18],"=",ложь)[1];
	Иначе
		СуммаДокументаСтр=СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(МассивСтрок[19],"=",ложь)[0];
	КонецЕсли;
	//СуммаДокумента=Лев(СокрЛП(СуммаДокументаСтр), СтрДлина(СокрЛП(СуммаДокументаСтр)) - 1);
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаШтрафаПриИзменении(Элемент)
	СтрокаШтрафаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ВнешнееСобытиеНаСервере(СтрокаШтрафа)
	
	МассивСтрок=СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаШтрафа, "|", Ложь);
	КодЛьготнаяДата = "";                   
	Для каждого СтрокаМассива Из МассивСтрок  Цикл
		Позиция = СтрНайти(СтрокаМассива,"=");
		НазваниеЭлемента = ВРег(Сред(СтрокаМассива,1,Позиция-1));
		Если НазваниеЭлемента = ВРег("PayeeINN") Тогда
			КодИННПлательщика = СтрокаМассива;
		ИначеЕсли НазваниеЭлемента = ВРег("CBC") Тогда
			КодCBC = СтрокаМассива;
		ИначеЕсли НазваниеЭлемента = ВРег("OKTMO") Тогда
			КодOKTMO = СтрокаМассива;
		ИначеЕсли НазваниеЭлемента = ВРег("ruleId") Тогда
			КодИдентификаторПлатежа = СтрокаМассива;
		ИначеЕсли НазваниеЭлемента = ВРег("DISCOUNT_DATE") Тогда  
			КодЛьготнаяДата = СтрокаМассива;
		ИначеЕсли НазваниеЭлемента = ВРег("Sum") Тогда
			КодСуммы = 	СтрокаМассива;
		ИначеЕсли НазваниеЭлемента = ВРег("DISCOUNT_SUM") Тогда
			КодДисконтнойСуммы = 	СтрокаМассива;
		ИначеЕсли НазваниеЭлемента = ВРег("quittDate") Тогда
			КодДатыПостановления = 	СтрокаМассива;
		ИначеЕсли НазваниеЭлемента = ВРег("KPP") Тогда
			//КодДКПП = 	СтрокаМассива;
			

	
		Иначе	

		КонецЕсли;
	
	КонецЦикла; 
	
	ВЦККодДатыПостановления = СтрЗаменить(СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КодДатыПостановления,"=",ложь)[1],"ю",".");
	ВЦККодДатыПостановленияВДАТУ = Дата(Сред(ВЦККодДатыПостановления,7,4),Сред(ВЦККодДатыПостановления,4,2),Сред(ВЦККодДатыПостановления,1,2));
	СуммаДокументаСтр=СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КодСуммы,"=",ложь)[1];
	ВЦКСуммаДокумента=Лев(СокрЛП(СуммаДокументаСтр), СтрДлина(СокрЛП(СуммаДокументаСтр)) - 2);
	Если КодЛьготнаяДата = "" ТОгда
		ЛьготнаяДата = ВЦККодДатыПостановленияВДАТУ + 60 * 60 * 24*20;	
		КодДисконтнойСуммы  = Число(ВЦКСуммаДокумента) / 2;
		
		Если ЛьготнаяДата<НачалоДня(ТекущаяДатаСеанса()) Тогда
			СуммаДокументаСтр = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КодСуммы,"=",ложь)[1];
			СуммаДокумента=Лев(СокрЛП(СуммаДокументаСтр), СтрДлина(СокрЛП(СуммаДокументаСтр)) - 2);
		Иначе
			СуммаДокумента= КодДисконтнойСуммы;
		КонецЕсли;
		
	Иначе
		ЛьготнаяДата=Дата(СтрЗаменить(СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КодЛьготнаяДата,"=",ложь)[1],"ю",".")+" 00:00:00");
		
		Если ЛьготнаяДата<НачалоДня(ТекущаяДатаСеанса()) Тогда
			СуммаДокументаСтр=СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КодСуммы,"=",ложь)[1];
		Иначе
			СуммаДокументаСтр=СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КодДисконтнойСуммы,"=",ложь)[1];
		КонецЕсли;
		СуммаДокумента=Лев(СокрЛП(СуммаДокументаСтр), СтрДлина(СокрЛП(СуммаДокументаСтр)) - 2);
		
	КонецЕсли;
	
	//Сообщить(МассивСтрок[15]);
	//Сообщить(МассивСтрок[16]);
	//Сообщить(МассивСтрок[17]);
	//Сообщить(МассивСтрок[18]);
	//
	Контрагент=Справочники.Контрагенты.НайтиПоРеквизиту("Инн",СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КодИННПлательщика,"=",ложь)[1]);
	Если Контрагент<>Справочники.Контрагенты.ПустаяСсылка() Тогда
		//ИННПолучателя=Контрагент.ИНН;
		//КПППолучателя=Контрагент.КПП;
		//СчетКонтрагента=Контрагент.ОсновнойБанковскийСчет;//ПолучитьСчет(Контрагент);
		//ТекстПолучателя=Контрагент.НаименованиеПолное;
	КонецЕсли;
	СтатусСоставителя="08";
	КодБК= СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КодCBC,"=",ложь)[1];
	КодОКАТО=СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КодOKTMO,"=",ложь)[1];
	ИдентификаторПлатежа=СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КодИдентификаторПлатежа,"=",ложь)[1];
	//НазначениеПлатежа="УИН "+ИдентификаторПлатежа +"/// Штраф по постановлению "+ИдентификаторПлатежа+" от "+СтрЗаменить(СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(МассивСтрок[17],"=",ложь)[1],"ю",".");
	
	
	// Постановление от 05.04.2021, штраф пдд. Сумма: 2500-00, НДС не облагается   - тк....
	//
	Если СОКРЛП(ЭтотОбъект.Организация.ИНН) = "5263079190"  Тогда
	
		НазначениеПлатежа = "Постановление от " + СтрЗаменить(СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КодДатыПостановления,"=",ложь)[1],"ю",".") + ", штраф пдд. Сумма: " + Строка(Формат(СуммаДокумента,"ЧДЦ=2; ЧРД=-; ЧГ=0")) + ", НДС не облагается";	
	
	Иначе
	  	// Штраф ПДД. Сумма: 250.00 НДС не облагается 
		НазначениеПлатежа = "Штраф ПДД. Сумма: " + Строка(Формат(СуммаДокумента,"ЧДЦ=2; ЧРД=.; ЧГ=0")) + ", НДС не облагается";	
	
	КонецЕсли;
	
	
	
	ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеНалога;
	ОчередностьПлатежа = 5;
	ВалютаДокумента = Константы.ВалютаРегламентированногоУчета.Получить();
	ПеречислениеВБюджет = Истина;
	
	//КПППлательщика = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КодДКПП,"=",ложь)[1];
	ВидПлатежа = "Электронно";
	Налог = Справочники.ВидыНалоговИПлатежейВБюджет.ПрочиеНалогиИСборы;
	СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоНаименованию("Прочие расходы");
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	//Если Источник = "СканерШтрихкода" Тогда 
	//    Если Событие = "ПолученШтрихкод" Тогда
			ВнешнееСобытиеНаСервере(Данные);		
	//	КонецЕсли;
	//КонецЕсли;
	
	
	
	//Сообщить(Данные);
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораНаСервере()
	//Вставить содержимое обработчика
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	ОбработкаВыбораНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ПравоДоступа("Чтение", Метаданные.Справочники.ПодключаемоеОборудование) Тогда
		ИспользуютсяСканерыШтрихкода = (МенеджерОборудованияВызовСервера.ОборудованиеПоПараметрам("СканерШтрихкода").Количество() > 0);
	Иначе
		ИспользуютсяСканерыШтрихкода = Ложь;
	КонецЕсли;
	
	ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеНалога;
	ОчередностьПлатежа = 5;
	ВалютаДокумента = Константы.ВалютаРегламентированногоУчета.Получить();
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОповещенияПриПодключении = Новый ОписаниеОповещения("ПодключитьСканерШКЗавершения", ЭтотОбъект, Новый Структура("Форма", ЭтаФорма));
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПоТипу(ОповещенияПриПодключении, ЭтаФорма.УникальныйИдентификатор, "СканерШтрихкода");
		
КонецПроцедуры
	
&НаКлиенте
Процедура ПодключитьСканерШКЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт

	Форма = ДополнительныеПараметры.Форма;
	Форма.СканерШтрихкодаПодключен = РезультатВыполнения.Результат;

КонецПроцедуры
	
	
