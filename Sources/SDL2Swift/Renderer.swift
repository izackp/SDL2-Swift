//
//  Renderer.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import SDL2

/// SDL Renderer
public final class Renderer {
    
    // MARK: - Properties
    
    internal let internalPointer: OpaquePointer
    
    // MARK: - Initialization
    
    deinit {
        SDL_DestroyRenderer(internalPointer)
    }
    
    /// Create a 2D rendering context for a window.
    public init(window: Window,
                driver: Renderer.Driver = .default,
                options: BitMaskOptionSet<Renderer.Option> = []) throws {
        
        let internalPointer = SDL_CreateRenderer(window.internalPointer, Int32(driver.rawValue), options.rawValue)
        self.internalPointer = try internalPointer.sdlThrow(type: type(of: self))
    }
    
    /// The color used for drawing operations (Rect, Line and Clear).
    public func drawColor() throws -> (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        
        var red: UInt8 = 0
        var green: UInt8 = 0
        var blue: UInt8 = 0
        var alpha: UInt8 = 0
        
        try SDL_GetRenderDrawColor(internalPointer, &red, &green, &blue, &alpha).sdlThrow(type: type(of: self))
        
        return (red, green, blue, alpha)
    }
    
    /// Set the color used for drawing operations (Rect, Line and Clear).
    public func setDrawColor(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8 = .max) throws {
        
         try SDL_SetRenderDrawColor(internalPointer, red, green, blue, alpha).sdlThrow(type: type(of: self))
    }
    
    /// Current rendering target texture.
    public private(set) var target: Texture?
    
    /// Set a texture as the current rendering target.
    public func swapTarget(_ newValue: Texture?) throws -> Texture? {
        
        let result = self.target
        try setTarget(newValue)
        return result
    }
    
    /// Set a texture as the current rendering target.
    public func setTarget(_ newValue: Texture?) throws {
        
        try SDL_SetRenderTarget(internalPointer, newValue?.internalPointer).sdlThrow(type: type(of: self))
        self.target = newValue
    }
    
    /// The blend mode used for drawing operations (Fill and Line).
    public func drawBlendMode() throws -> BitMaskOptionSet<BlendMode> {
        
        var value = SDL_BlendMode(0)
        SDL_GetRenderDrawBlendMode(internalPointer, &value)
        let idk:UInt32 = UInt32(value.rawValue)
        return BitMaskOptionSet<BlendMode>(rawValue:idk)
    }
    
    /// Set the blend mode used for drawing operations (Fill and Line).
    ///
    /// - Note: If the blend mode is not supported, the closest supported mode is chosen.
    public func setDrawBlendMode(_ newValue: BitMaskOptionSet<BlendMode>) throws {
        
        try SDL_SetRenderDrawBlendMode(internalPointer, SDL_BlendMode(Int32(newValue.rawValue))).sdlThrow(type: type(of: self))
    }
    
    /// Set a device independent resolution for rendering
    public func setLogicalSize(width: Int32, height: Int32) throws {
        
        try SDL_RenderSetLogicalSize(internalPointer, width, height).sdlThrow(type: type(of: self))
    }
    
    public func setClipRect(_ rect:SDL_Rect?) throws {
        guard var copy = rect else {
            let ptr:UnsafePointer<SDL_Rect>? = nil
            try SDL_RenderSetClipRect(internalPointer, ptr).sdlThrow(type: type(of: self))
            return
        }
        try SDL_RenderSetClipRect(internalPointer, &copy).sdlThrow(type: type(of: self))
    }
    
    public func getClipRect() -> SDL_Rect {
        var rect = SDL_Rect()
        SDL_RenderGetClipRect(internalPointer, &rect)
        return rect
    }
    
    public func isClipEnabled() -> Bool {
        return SDL_RenderIsClipEnabled(internalPointer) == SDL_TRUE
    }
    
    // MARK: - Methods
    
    /// Clear the current rendering target with the drawing color
    /// This function clears the entire rendering target, ignoring the viewport.
    public func clear() throws {
        
        try SDL_RenderClear(internalPointer).sdlThrow(type: type(of: self))
    }
    
    /// Update the screen with rendering performed.
    public func present() {
        
        SDL_RenderPresent(internalPointer)
    }
    
    /// Copy a portion of the texture to the current rendering target.
    public func copy(_ texture: Texture, source: SDL_Rect, destination: SDL_Rect) throws {
        var s = source
        var d = destination
        try SDL_RenderCopy(internalPointer, texture.internalPointer, &s, &d).sdlThrow(type: type(of: self))
    }
    
    /// Copy a portion of the texture to the current rendering target.
    public func copy(_ texture: Texture, source s: inout SDL_Rect, destination d: inout SDL_Rect) throws {
        try SDL_RenderCopy(internalPointer, texture.internalPointer, &s, &d).sdlThrow(type: type(of: self))
    }
    
    /// Copy a portion of the texture to the current rendering target.
    public func copy(_ texture: Texture, source: SDL_Rect) throws {
        var s = source
        try SDL_RenderCopy(internalPointer, texture.internalPointer, &s, nil).sdlThrow(type: type(of: self))
    }
    
    /// Copy a portion of the texture to the current rendering target.
    public func copy(_ texture: Texture, source s: inout SDL_Rect) throws {
        try SDL_RenderCopy(internalPointer, texture.internalPointer, &s, nil).sdlThrow(type: type(of: self))
    }
    
    /// Copy a portion of the texture to the current rendering target.
    public func copy(_ texture: Texture, destination: SDL_Rect) throws {
        var d = destination
        try SDL_RenderCopy(internalPointer, texture.internalPointer, nil, &d).sdlThrow(type: type(of: self))
    }
    
    /// Copy a portion of the texture to the current rendering target.
    public func copy(_ texture: Texture, destination d: inout SDL_Rect) throws {
        try SDL_RenderCopy(internalPointer, texture.internalPointer, nil, &d).sdlThrow(type: type(of: self))
    }
    
    /// Fill a rectangle on the current rendering target with the drawing color.
    public func fill(rect: SDL_Rect? = nil) throws {
        
        let rectPointer: UnsafePointer<SDL_Rect>?
        if let rect = rect {
            rectPointer = withUnsafePointer(to: rect) { $0 }
        } else {
            rectPointer = nil
        }
        
        try SDL_RenderFillRect(internalPointer, rectPointer).sdlThrow(type: type(of: self))
    }
    
    public func drawPoint(x:Int32, y:Int32) throws {
        try SDL_RenderDrawPoint(internalPointer, x, y).sdlThrow(type: type(of: self))
    }
}

// MARK: - Supporting Types

public extension Renderer {
    
    /// An enumeration of flags used when creating a rendering context.
    enum Option: UInt32, BitMaskOption {
        
        /// The renderer is a software fallback.
        case software = 0x00000001
        
        /// The renderer uses hardware acceleration.
        case accelerated = 0x00000002
        
        /// Present is synchronized with the refresh rate
        case presentVsync = 0x00000004
        
        /// The renderer supports rendering to texture
        case targetTexture = 0x00000008
    }
    
}

public extension Renderer {
    
    /// Information on the capabilities of a render driver or context.
    struct Info {
        
        /// The name of the renderer.
        public let name: String
        
        /// Supported options.
        public let options: BitMaskOptionSet<Renderer.Option>
        
        /// The number of available texture formats.
        public let formats: [PixelFormat.Format]
        
        /// The maximimum texture size.
        public let maximumSize: (width: Int, height: Int)
        
        public init(driver: Driver) throws {
            
            // get driver info from SDL
            var info = SDL_RendererInfo()
            try SDL_GetRenderDriverInfo(Int32(driver.rawValue), &info).sdlThrow(type: type(of: self))
            
            self.init(info)
        }
        
        internal init(_ info: SDL_RendererInfo) {
            
            self.name = String(cString: info.name)
            self.options = BitMaskOptionSet<Renderer.Option>(rawValue: info.flags)
            self.maximumSize = (Int(info.max_texture_width), Int(info.max_texture_height))
            
            // copy formats array
            let formatsCount = Int(info.num_texture_formats)
            let formats = [info.texture_formats.0,
                           info.texture_formats.1,
                           info.texture_formats.2,
                           info.texture_formats.3,
                           info.texture_formats.4,
                           info.texture_formats.5,
                           info.texture_formats.6,
                           info.texture_formats.7,
                           info.texture_formats.8,
                           info.texture_formats.9,
                           info.texture_formats.10,
                           info.texture_formats.11,
                           info.texture_formats.12,
                           info.texture_formats.13,
                           info.texture_formats.14,
                           info.texture_formats.15]
            
            self.formats = formats.prefix(formatsCount).map { PixelFormat.Format(rawValue: $0) }
        }
    }
}

public extension Renderer {
    
    struct Driver: IndexRepresentable {
        
        public static var all: CountableSet<Driver> {
            
            let count = Int(SDL_GetNumRenderDrivers())
            return CountableSet<Driver>(count: count)
        }
        
        public static let `default` = Driver(rawValue: -1)
        
        public let rawValue: Int
        
        public init(rawValue: Int) {
            
            self.rawValue = rawValue
        }
    }
}
