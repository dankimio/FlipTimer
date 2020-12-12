import SwiftUI

struct FeatureCell: View {
    var imageName: String
    var title: String
    var subtitle: String

    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32)
                .foregroundColor(.blue)

            VStack(alignment: .leading, spacing: 4, content: {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(subtitle)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            })

            Spacer()
        }
    }
}

struct FeatureCell_Previews: PreviewProvider {
    static var previews: some View {
        FeatureCell(
            imageName: "text.badge.checkmark",
            title: "Some Feature",
            subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        )
    }
}
