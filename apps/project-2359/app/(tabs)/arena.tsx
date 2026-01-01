import React, { useState } from 'react';
import { View, Pressable } from 'react-native';
import { H2, H3, P, Muted, Large } from '@/components/ui/typography';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Edit2, Mic, Check, X, RotateCcw } from 'lucide-react-native';

interface QuestionRendererProps {
    type: 'flashcard' | 'feynman' | 'quiz' | 'image-occlusion';
    question: string;
    showAnswer: boolean;
}

function QuestionRenderer({ type, question, showAnswer }: QuestionRendererProps) {
    switch (type) {
        case 'flashcard':
            return (
                <View className="items-center">
                    <H3 className="text-center mb-4">{question}</H3>
                    {showAnswer && (
                        <P className="text-center text-gray-600 border-t border-gray-100 pt-4 mt-4">
                            The mitochondria are known as the powerhouse of the cell, responsible for generating ATP through cellular respiration.
                        </P>
                    )}
                </View>
            );
        case 'feynman':
            return (
                <View className="items-center">
                    <H3 className="text-center mb-6">{question}</H3>
                    <Button variant="outline" className="h-20 w-20 rounded-full mb-4">
                        <Mic size={32} color="black" />
                    </Button>
                    <Muted>Tap to record your explanation</Muted>
                </View>
            );
        case 'image-occlusion':
            return (
                <View className="items-center">
                    <H3 className="text-center mb-4">{question}</H3>
                    <View className="h-48 w-full bg-gray-200 rounded-lg items-center justify-center">
                        <P>Image Occlusion Overlay</P>
                    </View>
                </View>
            );
        default:
            return <H3>{question}</H3>;
    }
}

export default function ArenaScreen() {
    const [showAnswer, setShowAnswer] = useState(false);
    const [mode, setMode] = useState<'flashcard' | 'feynman' | 'quiz' | 'image-occlusion'>('flashcard');

    return (
        <View className="flex-1 bg-white p-4">
            <View className="mt-12 mb-6">
                <View className="flex-row justify-between items-center mb-2">
                    <Muted>Cards Remaining: 42</Muted>
                    <Pressable onPress={() => { }}>
                        <Edit2 size={20} color="gray" />
                    </Pressable>
                </View>
                <View className="h-1 w-full bg-gray-100 rounded-full overflow-hidden">
                    <View className="h-full bg-black w-1/3" />
                </View>
            </View>

            <View className="flex-1 justify-center">
                <Card className="min-h-[300px] justify-center items-center p-8">
                    <CardContent>
                        <QuestionRenderer
                            type={mode}
                            question={mode === 'feynman' ? "Explain the Krebs Cycle" : "What is the primary function of the Mitochondria?"}
                            showAnswer={showAnswer}
                        />
                    </CardContent>
                </Card>
            </View>

            <View className="mt-8 mb-8">
                {!showAnswer ? (
                    <Button
                        className="h-14"
                        label="Show Answer"
                        onPress={() => setShowAnswer(true)}
                    />
                ) : (
                    <View className="flex-row justify-between">
                        <Button variant="outline" className="flex-1 mr-2 border-red-500" onPress={() => setShowAnswer(false)}>
                            <RotateCcw size={20} color="#ef4444" />
                            <P className="ml-2 text-red-500">Again</P>
                        </Button>
                        <Button variant="outline" className="flex-1 mr-2 border-orange-500" onPress={() => setShowAnswer(false)}>
                            <P className="text-orange-500">Hard</P>
                        </Button>
                        <Button variant="outline" className="flex-1 mr-2 border-blue-500" onPress={() => setShowAnswer(false)}>
                            <P className="text-blue-500">Good</P>
                        </Button>
                        <Button variant="outline" className="flex-1 border-green-500" onPress={() => setShowAnswer(false)}>
                            <P className="text-green-500">Easy</P>
                        </Button>
                    </View>
                )}
            </View>

            <View className="flex-row justify-center space-x-4 mb-4">
                <Button variant="ghost" onPress={() => setMode('flashcard')}>
                    <P className={mode === 'flashcard' ? 'font-bold' : ''}>Flashcard</P>
                </Button>
                <Button variant="ghost" onPress={() => setMode('feynman')}>
                    <P className={mode === 'feynman' ? 'font-bold' : ''}>Feynman</P>
                </Button>
                <Button variant="ghost" onPress={() => setMode('image-occlusion')}>
                    <P className={mode === 'image-occlusion' ? 'font-bold' : ''}>Occlusion</P>
                </Button>
            </View>
        </View>
    );
}
