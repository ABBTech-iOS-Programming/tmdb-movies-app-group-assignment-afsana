struct AccountStatesResponse: Decodable {
    let id: Int
    let favorite: Bool
    let watchlist: Bool
    let rated: RatedValue

    enum RatedValue: Decodable {
        case notRated(Bool)
        case rated(Double)

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let bool = try? container.decode(Bool.self) {
                self = .notRated(bool)
                return
            }

            if let obj = try? container.decode(RatedObject.self),
               let value = obj.value {
                self = .rated(value)
                return
            }

            if container.decodeNil() {
                self = .notRated(false)
                return
            }

            throw DecodingError.typeMismatch(
                RatedValue.self,
                .init(codingPath: decoder.codingPath,
                      debugDescription: "Unexpected type for rated")
            )
        }

        struct RatedObject: Decodable {
            let value: Double?
        }

        var value: Double? {
            switch self {
            case .rated(let v): return v
            case .notRated: return nil
            }
        }
    }
}
