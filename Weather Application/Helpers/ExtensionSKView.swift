//
//  ExtensionSKView.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 07.04.2023.
//

import Foundation
import SpriteKit

extension SKView {
 convenience init(withEmitter name: String) {
  self.init()

  self.frame = UIScreen.main.bounds
  backgroundColor = .clear

  let scene = SKScene(size: self.frame.size)
  scene.backgroundColor = .clear

  guard let emitter = SKEmitterNode(fileNamed: name + ".sks") else { return }
  emitter.name = name
     emitter.position = CGPoint(x: self.frame.size.width, y: self.frame.size.height)
     emitter.particlePositionRange = CGVector(dx: self.frame.size.width * 2, dy: 0)
  scene.addChild(emitter)
  presentScene(scene)
 }
}
