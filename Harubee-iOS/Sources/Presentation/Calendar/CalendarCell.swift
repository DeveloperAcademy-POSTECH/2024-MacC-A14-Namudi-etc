private struct CalendarCell: View {
  let date: Date
  let isSelected: Bool
  let harubee: Int
  
  private var isToday: Bool {
    date == Calendar.current.startOfDay(for: Date())
  }
  
  private var isPast: Bool {
    date < Calendar.current.startOfDay(for: Date())
  }
  
  private var backgroundColor: Color {
    if isSelected {
      return .main
    } else if isToday {
      return .mainBright
    }
    return .whiteDefault
  }
  
  private var textColor: Color {
    if isSelected || isToday {
      return .whiteDefault
    }
    return .textBlack
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Text(dayText)
        .font(.pretendardMedium_14)
        .foregroundStyle(textColor)
        .padding(.top, 5)
      
      Spacer()
      
      Text(amountText)
        .font(.pretendardMedium_12)
        .foregroundStyle(textColor)
        .padding(.bottom, 5)
    }
    .frame(height: 90)
    .frame(maxWidth: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 5)
        .fill(backgroundColor)
        .padding(1)
    )
    .padding(.vertical, 10)
    .contentShape(Rectangle())
  }
}

// MARK: - Calendar Cell Helper Properties
private extension CalendarCell {
  var dayText: String {
    let calendar = Calendar.current
    let day = calendar.component(.day, from: date)
    let month = calendar.component(.month, from: date)
    return day == 1 ? "\(month)/\(day)" : "\(day)"
  }
  
  var amountText: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter.string(from: NSNumber(value: harubee)) ?? "0"
  }
}