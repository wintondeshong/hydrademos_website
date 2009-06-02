﻿/*** MultiTween by Grant Skinner. Aug 12, 2005* Updated for AS3 and GTween Dec 14, 2008.* Visit www.gskinner.com/blog for documentation, updates and more free code.*** Copyright (c) 2008 Grant Skinner* * Permission is hereby granted, free of charge, to any person* obtaining a copy of this software and associated documentation* files (the "Software"), to deal in the Software without* restriction, including without limitation the rights to use,* copy, modify, merge, publish, distribute, sublicense, and/or sell* copies of the Software, and to permit persons to whom the* Software is furnished to do so, subject to the following* conditions:* * The above copyright notice and this permission notice shall be* included in all copies or substantial portions of the Software.* * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR* OTHER DEALINGS IN THE SOFTWARE.**/package com.gskinner.motion {		import com.gskinner.motion.GTween;	import flash.events.Event;		/**	* <b>MultiTween ©2008 Grant Skinner, gskinner.com. Visit www.gskinner.com/blog for documentation, updates and more free code.	* Licensed under the MIT license. See the source file header for more information.</b>	* <hr>	* MultiTween is a concept class to allow tweening multiple objects and properties with a single GTween instance.	* It is not thoroughly tested, and probably will exhibit some weird behaviours.	* <br/><br/>	* It is mostly provided in response to demand from users, and to give an example for building other extensions to GTween.	* <b>I generally would recommend using a single GTween instance per target, or GTweenTimeline over using this class.</b>	* <br/><br/>	* It works by setting itself as a target for the tween, and using it to tween the position property of MultiTween between 0 and 1.	* The position value is then used to calculate property values for all of the MultiTween's targets.	* In theory, this means that you can take advantage of most of the features of GTween (like delay and reflect).	* <br/><br/>	* Note that unlike GTween, which copies initProperties each time it inits (ie. starts tweening), MultiTween only copies those properties	* once the first time its associated GTween instance inits. This is in order to support features like autoReverse.	**/	public class MultiTween {				// Constants:		// Public Properties:		// Private Properties:		/** @private **/		protected var targets:Array;		/** @private **/		protected var destProperties:Object; // stores the destination property values.		/** @private **/		protected var initProperties:Array; // stores the initial property values of the target.		/** @private **/		protected var _position:Number=0;		/** @private **/		protected var _tween:GTween;			// Initialization:		/**		* Constructs a new MultiTween instance.		*		* @param targets An array of target objects whose properties will be tweened.		* @param properties Either an object describing the destination values for the tween that will be applied to all targets, or an array of those objects to apply to each of the targets independently.		* @param tween The GTween instance that will be controlling this MultiTween. This allows the MultiTween to set itself as the target of the tween, set up its position property for tweening, and listen for the init event.		**/		public function MultiTween(targets:Array, properties:Object, tween:GTween) {			this.targets = targets;			destProperties = properties;			_tween = tween;			tween.target = this;			tween.proxy.position = 1;			if (tween.state == GTween.TWEEN) {				copyInitProperties();			} else {				tween.addEventListener(Event.INIT, handleInit);			}		}			// Public Methods:		/**		* The property that is tweened by the GTween instance. This can also be set directly through code.		* For example, a position of 0.5 will tween all the target properties to halfway between their initial value and their destination value.		**/ 		public function get position():Number {			return _position;		}		public function set position(value:Number):void {			_position = value;			var l:int = targets.length;			for (var i:int=0; i<l; i++) {				var initProps:Object = initProperties[i];				if (initProps == null) { continue; }				var destProps:Object = destProperties is Array ? destProperties[i] : destProperties;				var target:Object = targets[i];				for (var n:String in initProps) {					target[n] = initProps[n]+value*(destProps[n]-initProps[n]);				}			}		}				/**		* Read-only access to the tween that is associated with this MultiTween instance.		**/ 		public function get tween():GTween {			return _tween;		}				// Protected Methods:		/** @private **/		protected function handleInit(evt:Event):void {			tween.removeEventListener(Event.INIT,handleInit);			copyInitProperties();		}				/** @private **/		protected function copyInitProperties():void {			var l:int = targets.length;			initProperties = [];			for (var i:int=0; i<l; i++) {				var props:Object = destProperties is Array ? destProperties[i] : destProperties;				if (props == null) {					initProperties[i] = null;					continue;				}				var target:Object = targets[i];				var initProps:Object = initProperties[i] = {};				for (var n:String in props) {					initProps[n] = target[n];				}			}		}	}	}