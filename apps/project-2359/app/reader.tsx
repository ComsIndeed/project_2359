import React, { useState } from 'react';
import { View, ScrollView, Pressable } from 'react-native';
import { H3, P, Muted, Large } from '@/components/ui/typography';
import { Button } from '@/components/ui/button';
import { ChevronLeft, MessageSquare, Highlighter, PlusSquare, Layers, X } from 'lucide-react-native';
import { useRouter } from 'expo-router';

export default function ReaderScreen() {
    const router = useRouter();
    const [showDrawer, setShowDrawer] = useState(false);

    return (
        <View className="flex-1 bg-white">
            {/* Header */}
            <View className="mt-12 px-4 py-2 flex-row items-center justify-between border-b border-gray-100">
                <Pressable onPress={() => router.back()}>
                    <ChevronLeft size={24} color="black" />
                </Pressable>
                <Large className="flex-1 text-center">Anatomy_Lecture_1.pdf</Large>
                <Button variant="ghost" size="icon" onPress={() => setShowDrawer(!showDrawer)}>
                    <MessageSquare size={24} color="black" />
                </Button>
            </View>

            <ScrollView className="flex-1 p-6">
                <H3 className="mb-4">The Skeletal System</H3>
                <P className="mb-4">
                    The human skeletal system is the internal framework of the human body. It is composed of around 270 bones at birth – this total decreases to around 206 bones by adulthood after some bones get fused together.
                </P>
                <View className="bg-yellow-100 p-1 rounded">
                    <P className="mb-4">
                        The bone mass in the skeleton reaches maximum density around age 21. The human skeleton can be divided into the axial skeleton and the appendicular skeleton.
                    </P>
                </View>
                <P className="mb-4">
                    The axial skeleton is formed by the vertebral column, the rib cage, the skull and other associated bones. The appendicular skeleton, which is attached to the axial skeleton, is formed by the shoulder girdle, the pelvic girdle and the bones of the upper and lower limbs.
                </P>

                {/* Mock Selection Menu */}
                <View className="bg-black rounded-lg flex-row p-2 self-center mt-4 shadow-xl">
                    <Button variant="ghost" size="sm" className="px-2">
                        <Highlighter size={18} color="white" />
                    </Button>
                    <View className="w-[1px] bg-gray-700 mx-1" />
                    <Button variant="ghost" size="sm" className="px-2">
                        <MessageSquare size={18} color="white" />
                    </Button>
                    <View className="w-[1px] bg-gray-700 mx-1" />
                    <Button variant="ghost" size="sm" className="px-2">
                        <PlusSquare size={18} color="white" />
                    </Button>
                    <View className="w-[1px] bg-gray-700 mx-1" />
                    <Button variant="ghost" size="sm" className="px-2">
                        <Layers size={18} color="white" />
                    </Button>
                </View>
            </ScrollView>

            {/* Context Drawer (Bottom Sheet Mock) */}
            {showDrawer && (
                <View className="absolute bottom-0 left-0 right-0 bg-white rounded-t-3xl shadow-2xl border-t border-gray-200 h-[40%] p-6">
                    <View className="flex-row justify-between items-center mb-4">
                        <H3>AI Companion</H3>
                        <Pressable onPress={() => setShowDrawer(false)}>
                            <X size={24} color="gray" />
                        </Pressable>
                    </View>
                    <ScrollView className="flex-1">
                        <View className="bg-gray-50 p-4 rounded-xl mb-4">
                            <P className="text-sm">Based on this page, would you like to generate flashcards for the difference between axial and appendicular skeletons?</P>
                            <Button variant="default" size="sm" className="mt-3" label="Generate 5 Cards" />
                        </View>
                        <View className="flex-row items-center p-2">
                            <View className="h-8 w-8 rounded-full bg-black items-center justify-center mr-3">
                                <MessageSquare size={16} color="white" />
                            </View>
                            <P className="text-sm text-gray-600">Ask me anything about this document...</P>
                        </View>
                    </ScrollView>
                </View>
            )}
        </View>
    );
}
