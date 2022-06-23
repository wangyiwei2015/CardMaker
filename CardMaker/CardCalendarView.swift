//
//  CalendarView.swift
//  CardMaker
//
//  Created by wyw on 2022/6/21.
//

import SwiftUI

struct CalendarView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    @Binding var selection: Int
    
    let interval: DateInterval
    let showHeaders: Bool
    let content: (Date, Bool) -> DateView
    
    let columns = Array(repeating: GridItem(spacing: 2), count: 7)

    init(
        interval: DateInterval,
        showHeaders: Bool = true,
        selection: Binding<Int>,
        @ViewBuilder content: @escaping (Date, Bool) -> DateView
    ) {
        self.interval = interval
        self.showHeaders = showHeaders
        self.content = content
        self._selection = selection
    }

    var body: some View {
        LazyVGrid(columns: columns) {sections}.padding(.bottom, 100)
    }
    
    @ViewBuilder func makeButton(_ month: Date, _ date: Date) -> some View {
        if calendar.isDate(date, equalTo: month, toGranularity: .month) {
            Button {
                selection = Int(DateFormatter.yyyyddmm.string(from: date))!
            } label: {
                content(date, calendar.isDate(date, equalTo: Date(), toGranularity: .day))
            }.buttonStyle(CalendarCellButtonStyle()).id(date)
        } else {
            content(date, false).hidden()
        }
    }
    
    @ViewBuilder var sections: some View {
        ForEach(months, id: \.self) { month in
            Section(header: header(for: month)) {
                ForEach(days(for: month), id: \.self) { date in
                    makeButton(month, date)
                }
                Spacer(minLength: 20)
            }
        }
    }

    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }

    private func header(for month: Date) -> some View {
        //let component = calendar.component(.month, from: month)
        let formatter = DateFormatter.monthAndYear //component == 1 ? DateFormatter.monthAndYear : .month

        return Group {
            if showHeaders {
                VStack {
                    Divider()
                    HStack {
                        Text(formatter.string(from: month))
                            .font(.title).bold()
                            .foregroundColor(.gray)
                            .padding()
                        Spacer()
                    }
                }
            }
        }
    }

    private func days(for month: Date) -> [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month),
            let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
            let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end)
        else { return [] }
        return calendar.generateDates(
            inside: DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end),
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
}

struct CardCalendarView: View {
    
    @Binding var selection: Int
    @Binding var cardDataList: [Int]
    @Binding var year: Int
    @Binding var month: Int
    
    func hasCard(_ date: Date) -> Bool {
        cardDataList.firstIndex(of: Int(DateFormatter.yyyyddmm.string(from: date))!) != nil
    }
    
    var body: some View {
        //NavigationView {
            VStack {
                ScrollView(.vertical) {
                    CalendarView(
                        interval: .init(
                            start: Calendar.current.date(from: DateComponents(year: year, month: month))!,
                            end: Calendar.current.date(from: DateComponents(year: year, month: month))!
                        ),
                        //interval: .init(),//Calendar.current.dateInterval(of: .year, for: Date())!,
                        selection: $selection
                    ) { date, isToday in
                        Text(DateFormatter.day.string(from: date))
                            .font(.system(size: 24, weight: .regular, design: .monospaced))
                            .foregroundColor(.primary)
                            .padding(8)
                            .background(Circle().fill(hasCard(date) ? Color("SelectionSecondary") : Color.clear))
                            .overlay {Circle().stroke(isToday ? Color.selection : Color.clear, lineWidth: 4)}
                    }.padding(.horizontal)
                }
            //}.navigationTitle("Title?")
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CardCalendarView(
            selection: .constant(20220621),
            cardDataList: .constant([20220618,20220620]),
            year: .constant(2022),
            month: .constant(6)
        )
        //.frame(height: 300)
        //.background(Color(UIColor.systemBackground).shadow(radius: 10))
    }
}

//--- Extensions ---

fileprivate extension DateFormatter {
    static var day: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return formatter
    }
    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM"
        return formatter
    }
    static var yyyyddmm: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }
}

fileprivate extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)

        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        return dates
    }
}
