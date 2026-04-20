//
//  HandCardView.swift
//  ImamApp
//
//  Created by Imam on 17/04/26.
//

import SwiftUI

// komponen card untuk tiap pilihan tangan
struct HandCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let flipIcon: Bool
    let coreColor: Color
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                action()
            }
        }) {
            HStack(spacing: 20) {

                // lingkaran icon
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(coreColor)
                            .frame(width: 56, height: 56)
                    } else {
                        Circle()
                            .fill(coreColor.opacity(0.2))
                            .frame(width: 56, height: 56)
                    }

                    if flipIcon {
                        Image(systemName: icon)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(isSelected ? .white : coreColor)
                            .rotationEffect(Angle(degrees: 45))
                    } else {
                        Image(systemName: icon)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(isSelected ? .white : coreColor)
                            .rotationEffect(Angle(degrees: 45))

                    }

                }

                // tulisan judul dan subtitle
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()

            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        isSelected
                            ? AnyShapeStyle(coreColor.opacity(0.04))
                            : AnyShapeStyle(
                                Color(
                                    uiColor: .secondarySystemGroupedBackground
                                )
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(
                        isSelected
                            ? AnyShapeStyle(Color.red)
                            : AnyShapeStyle(Color.clear),
                        lineWidth: 2
                    )
            )
            .shadow(
                color: isSelected
                    ? coreColor.opacity(0.2)
                    : Color.black.opacity(0.1),
                radius: 16,
                x: 0,
                y: 8
            )
        }
        .buttonStyle(.plain)
        //        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(
            .spring(response: 0.3, dampingFraction: 0.7),
            value: isSelected
        )
    }
}


// MARK: - STROKE CARD

// card untuk tiap jenis pukulan

struct StrokeCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let coreColor: Color
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {

                // lingkaran icon gradient
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(coreColor)
                            .frame(width: 56, height: 56)
                    } else {
                        Circle()
                            .fill(coreColor.opacity(0.12))
                            .frame(width: 56, height: 56)
                    }
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(isSelected ? .white : coreColor)

                }

                // teks judul dan subtitle
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        isSelected
                            ? AnyShapeStyle(coreColor.opacity(0.09))
                            : AnyShapeStyle(
                                Color(
                                    uiColor: .secondarySystemGroupedBackground
                                )
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(
                        isSelected
                            ? AnyShapeStyle(coreColor)
                            : AnyShapeStyle(Color.clear),
                        lineWidth: 2
                    )
            )
            .shadow(
                color: isSelected
                    ? coreColor.opacity(0.2)
                    : Color.black.opacity(0.1),
                radius: 16, x: 0, y: 8
            )
        }
        .buttonStyle(.plain)
        .animation(
            .spring(response: 0.3, dampingFraction: 0.7),
            value: isSelected
        )
    }
}
