import Foundation
import SourceryRuntime
import SwiftSyntax

extension GenericType {
    convenience init(name: String, node: GenericArgumentClauseSyntax) {
        #if compiler(>=6.2)
        // TODO: ExprSyntax may need to be handled
        let parameters = node.arguments.compactMap { argument -> GenericTypeParameter? in
            switch argument.argument {
            case .type(let type):
                let typeName = TypeName(type)
                guard !typeName.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
                return GenericTypeParameter(typeName: typeName)
            default: // case .expr
                return nil
            }
        }
        #else
        let parameters = node.arguments.compactMap { argument -> GenericTypeParameter? in
            let typeName = TypeName(argument.argument)
            guard !typeName.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
            return GenericTypeParameter(typeName: typeName)
        }
        #endif

        self.init(name: name, typeParameters: parameters)
    }
}
