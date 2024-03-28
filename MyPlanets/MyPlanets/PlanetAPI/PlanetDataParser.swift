//
//  PlanetDataParser.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 28/03/2024.
//

import Foundation
import CoreText

enum PlanetDataParsingError: Error {
    case cantParseDataNoStartAndEndKeys
    //            print("Recieved data doesn't include Planet Data: cannot find beginning and end of table marks")
    //            planetEfemeridData = PlanetDataEfemerid(date: Date(), rightAscension: 0, declination: 0, azimut: 0, elevation: 0, apparentSiderealTime: 0)
    //            print("It must be Earth, right?")
    case cantParseDataInvalidStartAdnEndKeys
    case cantParseTableCantFindLineWithData(within: String)
    case cantParseLineLengthIncorrect(notParsedLine: String)
    case cantParseDate(notParsedLine: String)
    case cantParseRightAscension(notParsedLine: String)
    case cantParseDeclination(notParsedLine: String)
    case cantParseAzimuth(notParsedLine: String)
    case cantParseElevation(notParsedLine: String)
    case cantParseAST(notParsedLine: String)
}

struct PlanetDataParser {
    
    static func calculateEfemerid(fromRawNASAData rawPlanetDataFromNASA: String) -> PlanetEfemerid {
        var efemerid: PlanetEfemerid
        do {
            let parsedEfemerid = try parseRawNASADataToEfemerid(rawPlanetDataFromNASA: rawPlanetDataFromNASA)
            efemerid = parsedEfemerid
        } catch PlanetDataParsingError.cantParseDataNoStartAndEndKeys
                    ,PlanetDataParsingError.cantParseDataInvalidStartAdnEndKeys {
            print("Cannot find data to parse, here is your data:")
            print(rawPlanetDataFromNASA)
            print("Returning empty efemerid!")
            let emptyEfemerid = PlanetEfemerid(NASAparsingSuccessful: false, date: Date(), rightAscension: 0, declination: 0, azimut: 0, elevation: 0, apparentSiderealTime: 0)
            efemerid = emptyEfemerid
        } catch PlanetDataParsingError.cantParseTableCantFindLineWithData(let notParsedTableData) {
            print("Problem with data in table:")
            print(notParsedTableData)
            print("Length = \(notParsedTableData.count)")
            print("Returning empty efemerid!")
            let emptyEfemerid = PlanetEfemerid(NASAparsingSuccessful: false, date: Date(), rightAscension: 0, declination: 0, azimut: 0, elevation: 0, apparentSiderealTime: 0)
            efemerid = emptyEfemerid
        } catch PlanetDataParsingError.cantParseLineLengthIncorrect(let notParsedLine)
                    ,PlanetDataParsingError.cantParseDate(let notParsedLine)
                    ,PlanetDataParsingError.cantParseRightAscension(let notParsedLine)
                    ,PlanetDataParsingError.cantParseDeclination(let notParsedLine)
                    ,PlanetDataParsingError.cantParseAzimuth(let notParsedLine)
                    ,PlanetDataParsingError.cantParseElevation(let notParsedLine)
                    ,PlanetDataParsingError.cantParseAST(let notParsedLine) {
            print("Cannot parse the line with data:")
            print(notParsedLine)
            print("Returning empty efemerid!")
            let emptyEfemerid = PlanetEfemerid(NASAparsingSuccessful: false, date: Date(), rightAscension: 0, declination: 0, azimut: 0, elevation: 0, apparentSiderealTime: 0)
            efemerid = emptyEfemerid
        } catch {
            print("Unexpected error: \(error).")
            print("Returning empty efemerid!")
            let emptyEfemerid = PlanetEfemerid(NASAparsingSuccessful: false, date: Date(), rightAscension: 0, declination: 0, azimut: 0, elevation: 0, apparentSiderealTime: 0)
            efemerid = emptyEfemerid
        }
        return efemerid
    }
    
    static func parseRawNASADataToEfemerid(rawPlanetDataFromNASA: String) throws -> PlanetEfemerid {
      
        try checkIfRaWDataIncludesTableWithData(rawTextDataToCheck: rawPlanetDataFromNASA)
        let cleanParsablePlanetDataTable = try cutCleanParsablePlanetData(from: rawPlanetDataFromNASA)
        let singleRowWithEfemerids = try cutFirstRowWithEfemeridData(from: cleanParsablePlanetDataTable)
        let planetDataEfemerid = try parseTextLineWithEfemeridsToEfemeridsData(line: String(singleRowWithEfemerids))
        return planetDataEfemerid
    }
    
    private static func checkIfRaWDataIncludesTableWithData(rawTextDataToCheck: String) throws {
        guard rawTextDataToCheck.contains("$$SOE") && rawTextDataToCheck.contains("$$EOE") else {
            print("ERROR checkIfRaWDataIncludesTableWithData")
            throw PlanetDataParsingError.cantParseDataNoStartAndEndKeys
        }
    }
    
    private static func cutCleanParsablePlanetData(from rawPlanetDataFromNASA: String) throws -> Substring {
        guard let indexStart = rawPlanetDataFromNASA.firstIndex(of: "$"),
              let indexEnd = rawPlanetDataFromNASA.lastIndex(of: "$") else {
            print("ERROR cutCleanParsablePlanetData")
            throw PlanetDataParsingError.cantParseDataNoStartAndEndKeys
        }

        let parsablePlanetDataTable = rawPlanetDataFromNASA[indexStart..<indexEnd]
        let cleanParsablePlanetDataTable = try clearParsablePlanetDataTableFromUnusedData(parsablePlanetDataTable: parsablePlanetDataTable)
        return cleanParsablePlanetDataTable
    }
       
    private static func clearParsablePlanetDataTableFromUnusedData(parsablePlanetDataTable: Substring) throws -> Substring {
        guard let indexTableStartOfFirstRowWithData = parsablePlanetDataTable.firstIndex(of: " ") else {
            print("ERROR clearParsablePlanetDataTableFromUnusedData")
            throw PlanetDataParsingError.cantParseDataInvalidStartAdnEndKeys
        }
        let indexTableEndOfLastRowWithData = parsablePlanetDataTable.index(before: parsablePlanetDataTable.endIndex)
        let cleanParsablePlanetDataTable = parsablePlanetDataTable[indexTableStartOfFirstRowWithData..<indexTableEndOfLastRowWithData]
        return cleanParsablePlanetDataTable
    }
    
    private static func cutFirstRowWithEfemeridData(from cleanParsablePlanetDataTable: Substring) throws -> Substring {
        guard let indexStartOfFirstLine = cleanParsablePlanetDataTable.firstIndex(of: " "),
              let indexEndOfFirstLine = cleanParsablePlanetDataTable.firstIndex(of: "\n") else {
            print("ERROR cutFirstRowWithEfemeridData")
            throw PlanetDataParsingError.cantParseTableCantFindLineWithData(within: String(cleanParsablePlanetDataTable))
        }
        let firstRowWithEfemerids = cleanParsablePlanetDataTable[indexStartOfFirstLine..<indexEndOfFirstLine]
        guard firstRowWithEfemerids.count == K.tableTextLineLenght else {         //parser assume fixed width of columns !!!
            throw PlanetDataParsingError.cantParseLineLengthIncorrect(notParsedLine: String(firstRowWithEfemerids))
        }
        return firstRowWithEfemerids
    }
    
    private static func parseTextLineWithEfemeridsToEfemeridsData(line: String) throws -> PlanetEfemerid {
        //Date
        let cutDate = cutDate(from: line)
        let parsedDate = try parseDate(fromDateString: String(cutDate))
        //RA
        let cutRA = cutRightAscention(from: line)
        let parsedRA = try parseRightAscention(fromRAString: String(cutRA))
        //DEC
        let cutDeclination = cutDeclination(from: line)
        let parsedDeclination = try parseDeclination(fromDeclinationString: String(cutDeclination))
        //Azimuth
        let cutAzimuth = cutAzimuth(from: line)
        let parsedAzimuth = try parseAzimuth(fromAzimuthString: String(cutAzimuth))
        //Elevation
        let cutElevation = cutElevetion(from: line)
        let parsedElevation = try parseElevation(fromEleveationString: String(cutElevation))
        //Apparent Sidereal Time
        let cutAST = cutAST(from: line)
        let parsedAST = try parseAST(fromASTString: String(cutAST))
        
        let parsedEfemeridData = PlanetEfemerid(NASAparsingSuccessful: true, date: parsedDate, rightAscension: parsedRA, declination: parsedDeclination, azimut: parsedAzimuth, elevation: parsedElevation, apparentSiderealTime: parsedAST)
        return parsedEfemeridData
    }

    //MARK: Parse Date
    private static func cutDate (from line: String) -> Substring {
        let startIndex = line.index(line.startIndex, offsetBy: K.dateStartIndex)
        let endIndex = line.index(startIndex, offsetBy: K.dateLength)
        let cutDate = line[startIndex..<endIndex]
        return cutDate
    }
    
    //TODO: przerobić DATE parsing !!!!!
    private static func parseDate (fromDateString dateString: String) throws -> Date {
        // this is not needed, hence mocked, because we are going to ask for coordinates on a specific date, rather than read dates, however we might want to retrieve batches of date to udpate/initialise database?
        // a course on working with dates https://www.hackingwithswift.com/books/ios-swiftui/working-with-dates
        print("Data do parsowania: \(dateString)")
        var dateComponents = DateComponents()
        dateComponents.year = 2022
        dateComponents.month = 3
    //wyciągamy dzień ze Stringa
        let startDayIndex = dateString.index(dateString.startIndex, offsetBy: 9)
        let endDayIndex = dateString.index(startDayIndex, offsetBy: 2)
        let dayString = dateString[startDayIndex..<endDayIndex]
        print("DayString = \(dayString)")
        dateComponents.day =  Int(dayString)
        dateComponents.timeZone = TimeZone.current
        //dateComponents.hour = 1 // to jest zeby nie było daty z poprzdniego dnia !!!, Dlaczego tak jest?
        let calendar = Calendar(identifier: .gregorian)
        let dateParsed = calendar.date(from: dateComponents)!
        print("Date parsed: \(dateParsed)")
        return dateParsed
    }
    
    //MARK: Right Ascention
    private static func cutRightAscention (from line: String) -> Substring {
        let startIndex = line.index(line.startIndex, offsetBy: K.rightAscStartIndex)
        let endIndex = line.index(startIndex, offsetBy: K.rightAscLenght)
        let cutRA = line[startIndex..<endIndex]
        return cutRA
    }

    private static func parseRightAscention (fromRAString raString: String) throws -> Double {
    //wyciągamy godziny
        let raHours = try cutRAHours(raString: raString)
    //wyciągamy minuty
        let raMinutes = try cutRAMinutes(raString: raString)
    //wyciągamy sekundy
        let raSeconds = try cutRASeconds(raString: raString)
        let parasedRA = raHours + raMinutes / K.minutesInHour + raSeconds / K.secondsInHour
        return parasedRA
    }
     
    private static func cutRAHours (raString: String) throws -> Double {
        let startIndex = raString.startIndex
        let endIndex = raString.index(startIndex, offsetBy: K.rightAscHourOffset)
        let raHoursString = raString[startIndex..<endIndex]
        guard let raHour = Double(raHoursString) else {
            throw PlanetDataParsingError.cantParseRightAscension(notParsedLine: raString + " Hours!")
        }
        return raHour
    }
    
    private static func cutRAMinutes (raString: String) throws -> Double {
        let startIndex = raString.index(raString.startIndex, offsetBy: K.rightAscMinuteStartIndex)
        let endIndex = raString.index(startIndex, offsetBy: K.rightAscMinuteOffset)
        let raMinutesString = raString[startIndex..<endIndex]
        guard let raMinutes = Double(raMinutesString) else {
            throw PlanetDataParsingError.cantParseRightAscension(notParsedLine: raString + " Minutes!")
        }
        return raMinutes
    }
    
    private static func cutRASeconds (raString: String) throws -> Double {
        let startIndex = raString.index(raString.startIndex, offsetBy: K.rightAscSecondsStartIndex)
        let endIndex = raString.index(startIndex, offsetBy: K.rightAscSecondsOffset)
        let raSecondsString = raString[startIndex..<endIndex]
        guard let raSeconds = Double(raSecondsString) else {
            throw PlanetDataParsingError.cantParseRightAscension(notParsedLine: raString + " Seconds!")
        }
        return raSeconds
    }
    
    //MARK: Declination
    private static func cutDeclination (from line: String) -> Substring {
        let startIndex = line.index(line.startIndex, offsetBy: K.declinationStartIndex)
        let endIndex = line.index(startIndex, offsetBy: K.declinationLenght)
        let cutDeclination = line[startIndex..<endIndex]
        return cutDeclination
    }

    private static func parseDeclination (fromDeclinationString declinationString: String) throws -> Double {
    //wyciągamy godziny
        let declinationHours = try cutDeclinationHours(declinationString: declinationString)
    //wyciągamy minuty
        let declinationMinutes = try cutDeclinationMinutes(declinationString: declinationString)
    //wyciągamy sekundy
        let declinationSeconds = try cutDeclinationSeconds(declinationString: declinationString)
        let parsedDeclination = declinationHours + declinationMinutes / K.minutesInHour + declinationSeconds / K.secondsInHour
        return parsedDeclination
    }
    
    private static func cutDeclinationHours (declinationString: String) throws -> Double {
        let startIndex = declinationString.startIndex
        let endIndex = declinationString.index(startIndex, offsetBy: K.declinationHourOffset)
        let declinationHoursString = declinationString[startIndex..<endIndex]
        guard let declinationHour = Double(declinationHoursString) else {
            throw PlanetDataParsingError.cantParseDeclination(notParsedLine: declinationString + " Hours!")
        }
        return declinationHour
    }
    
    private static func cutDeclinationMinutes (declinationString: String) throws -> Double {
        let startIndex = declinationString.index(declinationString.startIndex, offsetBy: K.declinationMinuteStartIndex)
        let endIndex = declinationString.index(startIndex, offsetBy: K.declinationMinuteOffset)
        let declinationMinutesString = declinationString[startIndex..<endIndex]
        guard let declinationMinutes = Double(declinationMinutesString) else {
            throw PlanetDataParsingError.cantParseDeclination(notParsedLine: declinationString + " Minutes!")
        }
        return declinationMinutes
    }
    
    private static func cutDeclinationSeconds (declinationString: String) throws -> Double {
        let startIndex = declinationString.index(declinationString.startIndex, offsetBy: K.declinationSecondsStartIndex)
        let endIndex = declinationString.index(startIndex, offsetBy: K.declinationSecondsOffset)
        let declinationSecondsString = declinationString[startIndex..<endIndex]
        guard let declinationSeconds = Double(declinationSecondsString) else {
            throw PlanetDataParsingError.cantParseDeclination(notParsedLine: declinationString + " Seconds!")
        }
        return declinationSeconds
    }
    
    //MARK: Azimuth
    private static func cutAzimuth (from line: String) -> Substring {
        let startIndex = line.index(line.startIndex, offsetBy: K.azimuthStartIndex)
        let endIndex = line.index(startIndex, offsetBy: K.azimuthLenght)
        let cutAzimuth = line[startIndex..<endIndex]
        return cutAzimuth
    }
    
    private static func parseAzimuth (fromAzimuthString azimuthString: String) throws -> Double {
        guard let parsedAzimuth = Double(azimuthString.trimmingCharacters(in: CharacterSet(charactersIn: " "))) else {
            throw PlanetDataParsingError.cantParseAzimuth(notParsedLine: azimuthString)
        }
        return parsedAzimuth
    }
    
    //MARK: Elevation
    private static func cutElevetion (from line: String) -> Substring {
        let startIndex = line.index(line.startIndex, offsetBy: K.elevationStartIndex)
        let endIndex = line.index(startIndex, offsetBy: K.elevationLenght)
        let cutElevation = line[startIndex..<endIndex]
        return cutElevation
    }
    
    private static func parseElevation (fromEleveationString elevationString: String) throws-> Double {
        guard let parsedElevation = Double(elevationString.trimmingCharacters(in: CharacterSet(charactersIn: " "))) else {
            throw PlanetDataParsingError.cantParseElevation(notParsedLine: elevationString)
        }
        return parsedElevation
    }
    
    //MARK: Apparent Sidereal Time
    private static func cutAST (from line: String) -> Substring {
        let startIndex = line.index(line.startIndex, offsetBy: K.astStartIndex)
        let endIndex = line.endIndex
        let cutAST = line[startIndex..<endIndex]
        return cutAST
    }

    private static func parseAST (fromASTString astString: String) throws -> Double {
    //wyciągamy godziny
        let astHours = try cutASTHours(astString: astString)
    //wyciągamy minuty
        let astMinutes = try cutASTMinutes(astString: astString)
    //wyciągamy sekundy
        let astSeconds = try cutASTSeconds(astString: astString)
        let parsedAST = astHours + astMinutes / K.minutesInHour + astSeconds / K.secondsInHour
        return parsedAST
     }
    
    private static func cutASTHours (astString: String) throws -> Double {
        let startIndex = astString.startIndex
        let endIndex = astString.index(startIndex, offsetBy: K.astHourOffset)
        let astHoursString = astString[startIndex..<endIndex]
        guard let astHour = Double(astHoursString) else {
            throw PlanetDataParsingError.cantParseAST(notParsedLine: astString + " Hours!")
        }
        return astHour
    }
    
    private static func cutASTMinutes (astString: String) throws -> Double {
        let startIndex = astString.index(astString.startIndex, offsetBy: K.astMinuteStartIndex)
        let endIndex = astString.index(startIndex, offsetBy: K.astMinuteOffset)
        let astMinutesString = astString[startIndex..<endIndex]
        guard let astMinutes = Double(astMinutesString) else {
            throw PlanetDataParsingError.cantParseAST(notParsedLine: astString + " Minutes!")
        }
        return astMinutes
    }
    
    private static func cutASTSeconds (astString: String) throws -> Double {
        let startIndex = astString.index(astString.startIndex, offsetBy: K.astSecondsStartIndex)
        let endIndex = astString.index(startIndex, offsetBy: K.astSecondsOffset)
        let astSecondsString = astString[startIndex..<endIndex]
        guard let astSeconds = Double(astSecondsString) else {
            throw PlanetDataParsingError.cantParseAST(notParsedLine: astString + " Seconds!")
        }
        return astSeconds
    }
}
