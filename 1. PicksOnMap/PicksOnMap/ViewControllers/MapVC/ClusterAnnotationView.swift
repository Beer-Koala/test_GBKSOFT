//
//  ClusterAnnotationView.swift
//  PicksOnMap
//
//  Created by BeerKoala on 6/13/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import MapKit

class ClusterAnnotationView: MKAnnotationView {

    enum SizeConstants: Int {
        case clusterSize = 40
        case innerCircleSize = 24
        case textSize = 20
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10) // Magic numbers - Offset center point to animate better with marker annotations
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()

        if let cluster = annotation as? MKClusterAnnotation {
            image = drawCount(cluster.memberAnnotations.count)
        }
    }

    private func drawCount(_ count: Int) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: SizeConstants.clusterSize.rawValue, height: SizeConstants.clusterSize.rawValue))
        return renderer.image { _ in
            // Fill full circle with red color
            UIColor.red.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: SizeConstants.clusterSize.rawValue, height: SizeConstants.clusterSize.rawValue)).fill()

            // Fill inner circle with white color
            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(x: (SizeConstants.clusterSize.rawValue - SizeConstants.innerCircleSize.rawValue) / 2,
                                        y: (SizeConstants.clusterSize.rawValue - SizeConstants.innerCircleSize.rawValue) / 2,
                                        width: SizeConstants.innerCircleSize.rawValue,
                                        height: SizeConstants.innerCircleSize.rawValue)).fill()

            // Finally draw count text vertically and horizontally centered
            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.black,
                               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: CGFloat(SizeConstants.textSize.rawValue))]
            let text = "\(count)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: CGFloat(SizeConstants.clusterSize.rawValue) / 2 - size.width / 2,
                              y: CGFloat(SizeConstants.clusterSize.rawValue) / 2 - size.height / 2,
                              width: size.width,
                              height: size.height)
            text.draw(in: rect, withAttributes: attributes)
        }
    }
}
