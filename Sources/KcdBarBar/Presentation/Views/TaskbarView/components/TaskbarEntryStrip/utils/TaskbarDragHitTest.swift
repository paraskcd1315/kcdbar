import CoreGraphics

/** Which entry slot a dragged pointer is over. */
enum TaskbarDragHitTest {
    static func key(at pointer: CGPoint, in slots: [String: CGRect], dragging: String?) -> String? {
        let hit = slots
            .filter { $0.key != dragging && $0.value.contains(pointer) }
            .min { distance(from: pointer, to: $0.value) < distance(from: pointer, to: $1.value) }

        return hit?.key
    }

    private static func distance(from pointer: CGPoint, to frame: CGRect) -> CGFloat {
        let dx = pointer.x - frame.midX
        let dy = pointer.y - frame.midY

        return dx * dx + dy * dy
    }
}
