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
    let content: (Date) -> DateView

    init(
        interval: DateInterval,
        showHeaders: Bool = true,
        selection: Binding<Int>,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.interval = interval
        self.showHeaders = showHeaders
        self.content = content
        self._selection = selection
    }

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 2), count: 7)) {
            ForEach(months, id: \.self) { month in
                Section(header: header(for: month)) {
                    ForEach(days(for: month), id: \.self) { date in
                        if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                            Button {
                                selection = Int(DateFormatter.yyyyddmm.string(from: date))!
                            } label: {
                                content(date)
                            }.buttonStyle(CalendarCellButtonStyle()).id(date)
                        } else {
                            content(date).hidden()
                        }
                    }
                }.padding(.bottom)
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
    
    var body: some View {
        //NavigationView {
            VStack {
                ScrollView(.vertical) {
                    CalendarView(
                        interval: Calendar.current.dateInterval(of: .year, for: Date())!,
                        selection: $selection
                    ) { date in
                        Text(DateFormatter.day.string(from: date))
                            .font(.system(size: 24, weight: .regular, design: .monospaced))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Circle().fill(Color.selection))
                    }.padding(.horizontal)
                }
            //}.navigationTitle("Title?")
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CardCalendarView(selection: .constant(20220621))
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
